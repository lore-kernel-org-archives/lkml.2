Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2CHSPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:15:45 -0500
Received: from mx2.netapp.com ([216.240.18.37]:58819 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab2CHSPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:15:43 -0500
X-IronPort-AV: E=Sophos;i="4.73,553,1325491200"; 
   d="scan'208";a="631830330"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Olga Kornievskaia <aglo@citi.umich.edu>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] NFSv4: Return the delegation if the server returns
 NFS4ERR_OPENMODE
Thread-Topic: [PATCH 2/2] NFSv4: Return the delegation if the server returns
 NFS4ERR_OPENMODE
Thread-Index: AQHM/LNZTVOlz2021kCDLkZUy1AmJZZhNRYAgAAGfYA=
Date: Thu, 8 Mar 2012 18:15:26 +0000
Message-ID: <1331230525.2472.39.camel@lade.trondhjem.org>
References: <87k42yjb0c.fsf@tucsk.pomaz.szeredi.hu>
	 <1331160049-3842-1-git-send-email-Trond.Myklebust@netapp.com>
	 <1331160049-3842-2-git-send-email-Trond.Myklebust@netapp.com>
	 <1331160049-3842-3-git-send-email-Trond.Myklebust@netapp.com>
	 <CAN-5tyG-w+ie3sxTwNA6e9x=CojxyDaJScJuCbS+9VE=yTmJNA@mail.gmail.com>
In-Reply-To: <CAN-5tyG-w+ie3sxTwNA6e9x=CojxyDaJScJuCbS+9VE=yTmJNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7C310C884A45542A58CEA6871992BC3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q28IFrWH024467

On Thu, 2012-03-08 at 12:52 -0500, Olga Kornievskaia wrote:
> wouldn't it be better for you to proactively return a read delegation
> then unnecessarily erroring?

If nobody else holds a delegation, then the NFS client is actually
allowed to keep its read delegation while writing to the file. It does
admittedly need to request an OPEN stateid for write in that case...
(See section 10.4 of RFC3530bis draft 16)

That said, in either case we do need to deal with the fact that a new
delegation may be granted after we return the old one. There is no
locking around the setattr call to prevent this.

> i also don't understand how this error occurs. doing a setattr in this
> case you must have used a non-special stateid. the server would only
> return an err_openmode if you sent the setattr with a read delegation
> stateid. i guess my question is what stateid would you use that from
> client's perspective represent a write-type state id but yet a server
> would flag as having wrong access type?

The read delegation stateid is being sent as per the prescription in
section 9.1.3.6 of RFC3530bis.

> also i'm curious why would a server, instead of returning
> err_openmode, would not first recall your read delegation?

It could, but why do so when it can just return an error value? The
presence of the delegation stateid in the SETATTR request allows it to
communicate directly to the client what the problem is without the need
for any callbacks.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
