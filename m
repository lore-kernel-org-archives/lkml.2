Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1CVO0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:26:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57611 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752328Ab1CVO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:26:35 -0400
Date: Tue, 22 Mar 2011 10:26:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <roger.quadros@nokia.com>
cc: gregkh@suse.de, <sshtylyov@mvista.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
In-Reply-To: <4D88AF6F.4050508@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1103221022340.2292-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Roger Quadros wrote:

> I have a question here.
> 
> The host can request us to send less or more than the actual TOC size, since it 
> has no clue how big it is.
> e.g. Linux host requests us to send only 12 bytes even though our formatted TOC 
> length is 20. In this case should we return fsg->data_size_from_cmnd instead of 
> actual TOC length?

No.  Always return the actual TOC length.

> e.g. Mac requests us to send 65534 bytes but our RAW TOC length is 37.
> The file storage driver seems to be zero padding our data response. So we 
> respond with 65534 bytes, 37 of TOC and remaining zero padded.
> 
> Can we do something like this to avoid unnecessary zero padded transfers?
> 
>          ret = fsg_get_toc(curlun, msf, format, buf);
>          if (ret < 0) {
>                  curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
>                  return -EINVAL;
>          } else if (ret > fsg->data_size_from_cmnd) {
>                  ret = fsg->data_size_from_cmnd;
>          } else {
>                  fsg->residue = ret;
>          }
>          return ret;

Not needed (and not correct).  The code at the end of do_scsi_command()  
already does this:

		reply = min((u32) reply, fsg->data_size_from_cmnd);
		...
		fsg->residue -= reply;

Alan Stern

