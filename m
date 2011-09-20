Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1ITRNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:13:36 -0400
Received: from mx2.netapp.com ([216.240.18.37]:12292 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1ITRNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:13:34 -0400
X-IronPort-AV: E=Sophos;i="4.68,412,1312182000"; 
   d="scan'208";a="583356816"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v4 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Date: Tue, 20 Sep 2011 10:13:31 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B47FE1E@SACMVEXC2-PRD.hq.netapp.com>
In-reply-to: <4E78BD5B.8090507@parallels.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Thread-Index: Acx3sUxGZ+semtI/RU+Qw38nq4SzfgABYWqA
References: <20110920101031.9861.18444.stgit@localhost6.localdomain6> <20110920101341.9861.51453.stgit@localhost6.localdomain6> <4E788F8C.20103@netapp.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B47FD10@SACMVEXC2-PRD.hq.netapp.com> <4E789679.1060601@parallels.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B47FD22@SACMVEXC2-PRD.hq.netapp.com> <4E78A4AF.1020303@parallels.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B47FD2B@SACMVEXC2-PRD.hq.netapp.com> <4E78BD5B.8090507@parallels.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Stanislav Kinsbursky" <skinsbursky@parallels.com>
Cc: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        <linux-nfs@vger.kernel.org>, "Pavel Emelianov" <xemul@parallels.com>,
        <neilb@suse.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bfields@fieldses.org>,
        <davem@davemloft.net>
X-OriginalArrivalTime: 20 Sep 2011 17:13:32.0294 (UTC) FILETIME=[9FA46260:01CC77B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8KHDjFA021968

> -----Original Message-----
> From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> Sent: Tuesday, September 20, 2011 12:21 PM
> To: Myklebust, Trond
> Cc: Schumaker, Bryan; linux-nfs@vger.kernel.org; Pavel Emelianov;
> neilb@suse.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> bfields@fieldses.org; davem@davemloft.net
> Subject: Re: [PATCH v4 1/8] SUNRPC: introduce helpers for reference
> counted rpcbind clients
> 
> 20.09.2011 18:38, Myklebust, Trond Ğ¿Ğ¸ÑˆĞµÑ‚:
> >> -----Original Message-----
> >> From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> >> Sent: Tuesday, September 20, 2011 10:35 AM
> >> To: Myklebust, Trond
> >> Cc: Schumaker, Bryan; linux-nfs@vger.kernel.org; Pavel Emelianov;
> >> neilb@suse.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> bfields@fieldses.org; davem@davemloft.net
> >> Subject: Re: [PATCH v4 1/8] SUNRPC: introduce helpers for reference
> >> counted rpcbind clients
> >>
> >> 20.09.2011 18:14, Myklebust, Trond Ğ¿Ğ¸ÑˆĞµÑ‚:
> >>
> >>>>>
> >>>>> Doesn't it  need to be protected by rpcb_clnt_lock too?
> >>>>>
> >>>>
> >>>> Nope from my pow. It's protected by rpcb_create_local_mutex. I.e.
> >>>> no one will change rpcb_users since it's zero. If it's non zero -
> >>>> we willn't get to rpcb_set_local().
> >>>
> >>> OK, so you are saying that the rpcb_users++ below could be replaced
> >>> by
> >> rpcb_users=1?
> >>>
> >>
> >> Yes, you right.
> >>
> >>> In that case, don't you need a smp_wmb() between the setting of
> >> rpcb_local_clnt/4 and the setting of rpcb_users? Otherwise, how do
> >> you guarantee that rpcb_users != 0 implies rpbc_local_clnt/4 != NULL?
> >>>
> >>
> >> We check rpcb_users under spinlock. Gain spinlock forces memory
> >> barrier, doesn't it?
> >
> > Yes, and so you don't need an smp_rmb() on the reader side. However,
> you still need to ensure that the processor which _sets_ the rpcb_users and
> rpcb_local_clnt/4 actually writes them in the correct order.
> >
> 
> Trond, I've thought again and realized, that even if these writes (rpcb_users
> and rpbc_local_clnt/4) will be done in reversed order, then no barrier
> required here.
> Because if we have another process trying to create those clients (it can't use
> them since it's not started yet) on other CPU, than it's waiting on creation
> mutex. When it will gain the mutex, we will have required memory barrier
> for us.
> 
> Or I missed something in your explanation?

You need to ensure that if someone calls rpcb_get_local() and gets a positive result, then they can rely on rpcb_local_clnt/4 being non-zero. Without the write barrier, that is not the case.

Without that guarantee, you can't really ensure that rpcb_put_local() will work as expected either, since it will be possible to trigger the --rpcb_users == 0 case without shutting down rpcb_local_clnt/4 (because clnt/clnt4 == 0).

Cheers
  Trond

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
