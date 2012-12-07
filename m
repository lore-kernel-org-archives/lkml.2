Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2LGX4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:56:04 -0500
Received: from mx2.netapp.com ([216.240.18.37]:45140 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab2LGXz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:55:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,241,1355126400"; 
   d="scan'208";a="717092102"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Pavel Shilovsky <piastry@etersoft.ru>,
        Christoph Hellwig <hch@infradead.org>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "wine-devel@winehq.org" <wine-devel@winehq.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: RE: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Thread-Topic: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Thread-Index: AQHN099DvIAvKPJIs02UpfW1+Nk7hJgOCqoAgABKqAD//63SQA==
Date: Fri, 7 Dec 2012 23:55:39 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90B33D95E@SACEXCMBX04-PRD.hq.netapp.com>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
 <20121207161602.GA17710@infradead.org>
 <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
In-Reply-To: <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB7NuArj029042

> -----Original Message-----
> From: linux-nfs-owner@vger.kernel.org [mailto:linux-nfs-
> owner@vger.kernel.org] On Behalf Of Pavel Shilovsky
> Sent: Friday, December 07, 2012 9:43 PM
> To: Christoph Hellwig
> Cc: linux-cifs@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> fsdevel@vger.kernel.org; wine-devel@winehq.org; linux-
> nfs@vger.kernel.org
> Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
> 
> Christoph Hellwig Ğ¿Ğ¸ÑĞ°Ğ» 07.12.2012 20:16:
> > On Thu, Dec 06, 2012 at 10:26:28PM +0400, Pavel Shilovsky wrote:
> >> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags -
> >> this change can benefit cifs and nfs modules. While this change is ok
> >> for network filesystems, itsn't not targeted for local filesystems
> >> due security problems (e.g. when a user process can deny root to
> >> delete a file).
> >>
> >> Share flags are used by Windows applications and WINE have to deal
> >> with them too. While WINE can process open share flags itself on
> >> local filesystems, it can't do it if a file stored on a network share
> >> and is used by several clients. This patchset makes it possible for
> >> CIFS/SMB2.0/SMB3.0.
> >
> > I don't think introducing user visible flags that are only supported
> > on a single network filesystem is a good idea.
> 
> It can bring benefits for both CIFS and NFS filesystems - so, at least two ones.
> 
> >
> > I'm not even sure adding these flags does make a lot of sense, but
> > assuming we'd actually want this (and I'd like some more detailed
> > explanation) I think we'd at least need to make sure that:
> >
> >  a) opening files with the new modes gives a proper error message if
> > not
> >     supported
> 
> It makes us add such checks for all other filesystems, if I understand right, -
> not a problem, I think.
> 
> >  b) there needs to be local support for them as well
> >  c) we need to think really hard when they should be supported, and
> > need
> >     a good rational for it.  I can't see how we could do it
> >     unconditionally for all users as that would introduce easy denial
> >     of services attacks the way I understand the semantics (correct me
> >     if I'm wrong).  So a mount option like you currently do probably
> > is
> >     the least bad even if don't fell overly happy about that version.
> >
> > What is the reason your special wine use case can't simply use a
> > userspace cifs client?  Given that wine uses windows filesystem
> > semantics and cifs does as well tunnelling it through a Posix-like API
> > inbetween is never going to be perfect.
> 
> Ideally we should not make any difference between underlying filesystems
> in Wine: an application requests an open of the file and we issue this open
> with flags it passed. Since Wineserver can process share flags locally itself (for
> one linux user), we only need to add this support for CIFS (that is actively
> used by Wine applications because of it's Windows nature). Bringing these
> flags for local filesystems can benefit Wine too: it will help in cases when
> Wine applications of different users on the same machine use the same file
> and can make all those things easier, of course.
> 
> The problem is the possibility of denial-of-service attacks here. We can try to
> prevent them by:
> 1) specifying an extra security bit on the file that indicates that share flags are
> accepted (like we have for mandatory locks now) and setting it for
> neccessary files only, or
> 2) adding a special mount option (but it it probably makes sense if we
> decided to add this support for CIFS and NFS only).

Why not just put it under the control of LSM? It seems to me that this doesn't so much want to be a per-mount switch but rather deserves to be a per-process MAC (i.e. is this running in a Wine sandbox or not)...

Cheers
   Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
