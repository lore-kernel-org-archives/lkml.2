Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2EOL7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:59:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab2EOL7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:59:19 -0400
Date: Tue, 15 May 2012 14:59:17 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515115917.GK32036@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
 <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB23C09.7060300@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:20:41PM +0200, Hannes Reinecke wrote:
> On 05/15/2012 01:12 PM, Gleb Natapov wrote:
> > Next time you resent an email say why you are doing it (wrong lkml
> > address in this case).
> > 
> > On Tue, May 15, 2012 at 01:04:49PM +0200, Hannes Reinecke wrote:
> >> The device_path_info_length for EDD 3.0 is 36, not 44.
> >> Cf http://mbldr.sourceforge.net/specsedd30.pdf.
> >>
> > That's the wrong spec.
> > 
> Ah-ha.
> Why?
www.t13.org/documents/UploadedDocuments/docs2008/e08134r0-BIOS_Enhanced_Disk_Drive_Services_4.0.doc

> 
> >> This is a regression introduced by commit
> >> 0c61227094b3ddaca2f847ee287c4a2e3762b5a2
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> Cc: Gleb Natapov <gleb@redhat.com>
> >> Cc: H. Peter Anvin <hpa@linux.intel.com>
> >>
> >> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> >> index e229576..09a77d5 100644
> >> --- a/drivers/firmware/edd.c
> >> +++ b/drivers/firmware/edd.c
> >> @@ -545,8 +545,8 @@ edd_has_edd30(struct edd_device *edev)
> >>  	}
> >>  
> >>  
> >> -	/* We support only T13 spec */
> >> -	if (info->params.device_path_info_length != 44)
> > Here is the spec that code supports is spelled out, but you just replace
> > the comment with pointer to the spec that the code does not support.
> > 
> Hmm? How so?
> 
> I have this EDD info:
> 
> # hexdump -C raw_data
> 00000000  1e 00 03 00 14 04 00 00  ff 00 00 00 3f 00 00 00
> |............?...|
> 00000010  00 00 00 01 00 00 00 00  00 02 ff ff ff ff dd be
> |................|
> 00000020  24 00 00 00 50 43 49 00  46 49 42 52 45 00 00 00
> |$...PCI.FIBRE...|
> 00000030  07 00 00 00 00 00 00 00  50 01 43 80 01 3c 94 48
> |........P.C..<.H|
> 00000040  01 c8 00 00 00 00 00 00  00 00                    |..........|
> 
> which used to be perfectly valid, contains an 'interface_type'
> string, and a device path. All perfectly okay.
> And, as mentioned, used to be displayed ok prior to the mentioned
> commit.
> 
It is valid according to one spec but invalid according to another.

> So why do you claim we can't display it anymore?
> 
Before commit 0c61227094b3ddaca2f847ee287c4a2e3762b5a2 the code didn't
calculate checksum correctly. The check always succeed, so when bios
provided information according to T13 EDD4.0 spec interface_type contained
garbage. After the commit checksum is calculated correctly, but according
to T13 EDD4.0 spec, so for BIOSes that supply info according to another
spec check fails. Since T13 EDD4.0 spec support modern interfaces (RAID,
SATA, SAS) which another spec omits, and for interfaces they both support
T13 EDD4.0 actually supply enough information to link edd entry to actual
device (another spec does not), I do not see support for other spec to
be important, but you are welcome to write support for it if you need
it. The only way I see to check what spec edd info corresponds to is to
calculate checksum according to both specs and see which one succeeds.

--
			Gleb.
