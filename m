Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab0KTBzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:55:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:46017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab0KTBzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:55:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,226,1288594800"; 
   d="scan'208";a="679286242"
Date: Fri, 19 Nov 2010 17:55:19 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] [USB] UAS: Achitecture; TMF; more
Message-ID: <20101120015519.GA20191@xanatos>
References: <130.74979.qm@web31805.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <130.74979.qm@web31805.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 09:46:49PM -0700, Luben Tuikov wrote:
>  * Fix sense IU layout
> 
>  * Command delivery to the service delivery subsystem should
>    be an atomic transaction. Fix this in this driver by
>    removing the work thread which retried allocating and
>    sending urbs. First allocate the urbs we'll need up
>    front; second recycle them (sense<-RRIU in High-Speed
>    UAS); third if any operation with the SDS fails, report
>    this to the application client.
> 
>  * Rename uas_dev_info->uas_tport_info to more correctly
>    portray the capabilities of the target port. Decouple
>    that from the sdev structure as it now has a uas_lu_info
>    (new) which assists in TMF processing and error
>    recovery. So now uas_cmd_info lives in scsi_cmd;
>    uas_lu_info lives in scsi_device and uas_tport_info lives
>    in scsi_host.
> 
>  * Redo uas_sense. Make it more general and print a more
>    informative message if the sense data were short.
> 
>  * uas_xfer_data for High-Speed doesn't retry but fails if
>    the SDS is down. This means that we cannot reach the
>    target port, so we let error recovery kick in.
> 
>  * Add common urb initializers/fillers for the command and
>    status pipe. This generalizes output transactions on the
>    command pipe to always free the urb and the buffer, and
>    input transactions on the status pipe to always have a
>    buffer holding the max size of struct sense_iu and
>    complete in the same place, uas_stat_cmplt, in order to
>    accommodate both High-Speed devices and SuperSpeed
>    (USB3.0) devices.
> 
>  * Gracefully free the urbs if the SDS is down or we have no
>    memory for all urbs, at queuecommand entry.
> 
>  * Fix a shortcoming of SCSI Core where some commands coming
>    into the driver are NOT tagged and some are tagged. The
>    SDS (UAS) needs everything to be tagged and tagged
>    correctly. Use tag 1 for untagged commands and tags 2 to
>    FFEFh for tagged commands. In practice we use much less
>    and target ports will report much less than that.
> 
>  * If the target port is SuperSpeed request a macro defined
>    number of streams (128) for this I_T nexus. Target ports
>    will report less. If usb_alloc_streams complains, we know
>    we can handle at least one stream. Else if the port is
>    High-Speed, set the number of tags we use to some sane
>    value (32). Else the desired number of tags is set.
> 
>  * Implement TMF. All TMFs are supported. As we're not in
>    control of the tags, nor can we, at the time of this
>    commit, request a free tag from the block layer, we
>    allocate tags for TMFs with range [130, 1153]
>    (130+1024-1), as an increasing sequence.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
> 
> This patch changes 86% of the driver. More is to come, but this is
> a self-contained patch so it can be applied.
> 
>  drivers/usb/storage/uas.c |  970 ++++++++++++++++++++++++++++++---------------
>  1 files changed, 656 insertions(+), 314 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index ef6e707..ed1a82f 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -4,6 +4,7 @@
>   *
>   * Copyright Matthew Wilcox for Intel Corp, 2010
>   * Copyright Sarah Sharp for Intel Corp, 2010
> + * Copyright Luben Tuikov, 2010
>   *
>   * Distributed under the terms of the GNU GPL, version two.
>   */
> @@ -13,6 +14,7 @@
>  #include <linux/types.h>
>  #include <linux/usb.h>
>  #include <linux/usb/storage.h>
> +#include <linux/completion.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_dbg.h>
> @@ -29,12 +31,18 @@
>  #define UAS_DPRINTK(fmt, ...)
>  #endif
>  
> +/* Define the number of streams to ask to allocate, essentially
> + * the maximum number of tags which we are asking to be able to send
> + * to the device.  Devices may report much less.
> + */
> +#define UAS_MAX_STREAMS	128
> +

Why do you limit the number of streams this way?  USB 3.0 devices can
support up to 65533 streams, so why place an arbitrary limit like this?
Just use the MaxStreams field in the SuperSpeed Endpoint Companion
descriptor in the call to usb_alloc_streams().  I don't see how limiting
the number of streams you allocate to 128 when the original driver tried
to allocate 256 is an improvement.

<snip>

> -struct uas_dev_info {
> +/* Lives in the SCSI host, hostdata points to it.
> + */
> +struct uas_tport_info {
>  	struct usb_interface *intf;
>  	struct usb_device *udev;
> -	int qdepth;
> +	int num_tags;
>  	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
>  	unsigned use_streams:1;
>  	unsigned uas_sense_old:1;
>  };

Couldn't the renaming code could have made it into a separate
patch?  It also makes it hard to wade through the changes.  You should
have two patches at least: one to rename uas_dev_info, and one to rename
qdepth.  There's places in the code where you've changed how you use
qdepth, and it's hard to see because the rename and change are in one
patch.

Matthew and you can dicker over the name for uas_dev_info, but I really
don't understand your reasoning for renaming it to uas_tport_info.  What
type of "ports" are you talking about?  USB ports or some other type of
ports?  To me, uas_dev_info made sense because it stored information
about the particular UAS device, not the USB port it was attached to...

>  
> -enum {
> -	ALLOC_STATUS_URB	= (1 << 0),
> -	SUBMIT_STATUS_URB	= (1 << 1),
> -	ALLOC_DATA_IN_URB	= (1 << 2),
> -	SUBMIT_DATA_IN_URB	= (1 << 3),
> -	ALLOC_DATA_OUT_URB	= (1 << 4),
> -	SUBMIT_DATA_OUT_URB	= (1 << 5),
> -	ALLOC_CMD_URB		= (1 << 6),
> -	SUBMIT_CMD_URB		= (1 << 7),
> +/* Lives in the scsi device, hostdata points to it.
> + */
> +struct uas_lu_info {
> +	struct completion tmf_completion;
> +	struct resp_iu resp;
> +	struct urb *freed_urb;
>  };
>  
> -/* Overrides scsi_pointer */
> +/* Lives in the scsi command, overrides SCp.
> + */
>  struct uas_cmd_info {
> -	unsigned int state;
> -	unsigned int stream;
> +	int tag;

Tag ID or stream ID is the same, I suppose.  But stream IDs are always
positive integers, so why should tag be signed?

>  	struct urb *cmd_urb;
>  	struct urb *status_urb;
>  	struct urb *data_in_urb;
>  	struct urb *data_out_urb;
> -	struct list_head list;
>  };

<snip>

> -		sdev->current_cmnd = NULL;
> +/* ---------- Error Recovery ---------- */
>  
> -		cmnd->result = DID_NO_CONNECT << 16;
> -		done(cmnd);
> -	}
> +/* [1, UAS_MAX_STREAMS+1] belong to commands.
> + * [UAS_MAX_STREAMS+2, UAS_MAX_STREAMS+2+TMF_MAX_TAGS) belong to TMFs.

I'm a bit confused by this comment, perhaps because you didn't explain
what TMFs are in your comment or your commit message.

However, if you're telling the xHCI driver to allocate UAS_MAX_STREAMS,
the UAS driver gets to put stream ID 1 to stream ID UAS_MAX_STREAMS in
urb->stream_id.  If you submit an URB with urb->stream_id greater than
UAS_MAX_STREAMS, the xHCI driver is going to reject that submission.

It looks like from the comment you expect to be able to use a stream ID
as big as UAS_MAX_STREAMS+2+TMF_MAX_TAGS, is that what you were trying
to do?

Sarah Sharp
