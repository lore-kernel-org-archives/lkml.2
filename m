Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031960Ab2COXEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:04:10 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:21191
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031159Ab2COXED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:04:03 -0400
X-SpamScore: -18
X-BigFish: VS-18(zz9371I936eK542M1432N98dKzz1202hzzz2fh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Thread-Index: AQHM+LUYOjJW5Du7G0WJSaUrHj4mnJZZ3GmAgABVn8CAAAhLgIARy8Ow
Date: Thu, 15 Mar 2012 23:03:45 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B76631A@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
	 <20120304091225.GA27297@infradead.org>
	 <6E21E5352C11B742B20C142EB499E0481B74886F@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <1330872513.2858.14.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1330872513.2858.14.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.19]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2FN4I9l007245



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Sunday, March 04, 2012 9:49 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com; linux-scsi@vger.kernel.org;
> Haiyang Zhang
> Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On Sun, 2012-03-04 at 14:23 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > Sent: Sunday, March 04, 2012 4:12 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> > > jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> > > Haiyang Zhang
> > > Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> > > the host
> > >
> > > On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > > > Windows hosts don't handle the ATA_16 command; don't pass it to the
> host.
> > >
> > > Most devices don't handle it, and answer with and unsupported opcode
> > > sense reason.  If hyperv iis buggy enough to crap out on it please add
> > > a comment explaining that.
> >
> > The host does not "crap out", it does return an error code but it is not
> "unsupported opcode".
> > The sense reason that comes back is a generic error SRB_STATUS code. It is
> easier for me to filter the
> > command on the outgoing side as opposed to dealing with a generic error code
> that is coming back from
> > the host.
> 
> That's the wrong thing to do ... you need to unwrap the error code.
> The reason being I presume it's not impossible for Windows to host a
> device supporting ATA_16 and there are signs that this is going to be
> necessary to prevent data corruption on some USB devices ... if you just
> filter the command without checking if the host supports it, you're
> going to end up perpetuating the corruption problem.

James,

Currently, the Windows host does not provide me with granular error codes to 
distinguish between the case where the operation failed and the case where it is
an illegal or unsupported operation. I have asked the windows team to return more
appropriate error codes and they may do that sometime soon. In the interim, filtering
the command on the outgoing path is the best way I can deal with this issue. Currently,
even on the host side they are filtering this command, except they are returning a failure
to the guest instead of a more appropriate error code.
While my proposal has been accepted for windows 8, I don't know when this change will ship.
Also, it is not clear when prior versions of Windows hosts that we care about will pick up this
change. This patch is the only way I know how to deal with this problems within my current
constraints.

Regards,

K. Y


> 
> The general rule of thumb for avoiding this is to let the lower layers
> handle as much as possible, and only begin behaviour alterations in the
> upper layers if the lower layers have a provable and usually fatal
> failure.
> 
> James
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
