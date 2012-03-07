Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab2CGPlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:41:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52809 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab2CGPk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:40:56 -0500
Message-ID: <1331134846.2474.73.camel@edumazet-laptop>
Subject: Re: [PATCH 6/6] Netfilter: xt_LOG: Add timestamp support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Richard Weinberger <richard@nod.at>, jengelh@medozas.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, rostedt@goodmis.org
Date: Wed, 07 Mar 2012 07:40:46 -0800
In-Reply-To: <20120307152910.GA7044@1984>
References: <1330989588-26833-1-git-send-email-richard@nod.at>
	 <1330989588-26833-7-git-send-email-richard@nod.at>
	 <20120307152910.GA7044@1984>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 mars 2012 à 16:29 +0100, Pablo Neira Ayuso a écrit :
> On Tue, Mar 06, 2012 at 12:19:48AM +0100, Richard Weinberger wrote:
> > Using XT_LOG_ADD_TIMESTAMP it is possible to have a timestamp
> > directly in the log message.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  include/linux/netfilter/xt_LOG.h |    3 ++-
> >  net/netfilter/xt_LOG.c           |    8 ++++++++
> >  2 files changed, 10 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
> > index 8ac25e0..9361374 100644
> > --- a/include/linux/netfilter/xt_LOG.h
> > +++ b/include/linux/netfilter/xt_LOG.h
> > @@ -8,7 +8,8 @@
> >  #define XT_LOG_UID		0x08	/* Log UID owning local socket */
> >  #define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
> >  #define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
> > -#define XT_LOG_MASK		0x2f
> > +#define XT_LOG_ADD_TIMESTAMP	0x40    /* Add a timestamp */
> > +#define XT_LOG_MASK		0x6f
> >  
> >  struct xt_log_info {
> >          unsigned char level;
> > diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
> > index f75f2d7..23db206 100644
> > --- a/net/netfilter/xt_LOG.c
> > +++ b/net/netfilter/xt_LOG.c
> > @@ -499,6 +499,14 @@ log_packet_common(struct sbuff *m,
> >  	if (loginfo->type == NF_LOG_TYPE_LOG)
> >  		sb_add(m, "<%d>", loginfo->u.log.level);
> >  
> > +	if (loginfo->u.log.logflags & XT_LOG_ADD_TIMESTAMP) {
> > +		struct timespec tv;
> > +
> > +		getnstimeofday(&tv);
> > +		sb_add(m, "TIMESTAMP=%li.%03u ", tv.tv_sec,
> > +			(unsigned int)tv.tv_nsec / NSEC_PER_MSEC);
> 
> net/netfilter/xt_LOG.c: In function ‘log_packet_common’:
> net/netfilter/xt_LOG.c:507:4: warning: format ‘%u’ expects argument of
> type ‘unsigned int’, but argument 4 has type ‘long int’ [-Wformat]
> 
> It has to be:
> 
>                 sb_add(m, "TIMESTAMP=%li.%03u ", tv.tv_sec,
>                         (unsigned int)(tv.tv_nsec / NSEC_PER_MSEC));
>                                       ^                          ^
> I've fixed, no need to resend this patch.

This is why I submitted the "netfilter: ipt_LOG: add __printf() to
sb_add()" patch :)



