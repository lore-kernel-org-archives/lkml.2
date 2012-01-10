Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab2AJRrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:47:47 -0500
Received: from mx2.netapp.com ([216.240.18.37]:30819 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab2AJRrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:47:46 -0500
X-IronPort-AV: E=Sophos;i="4.71,488,1320652800"; 
   d="scan'208";a="615317817"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [GIT PULL] Please pull NFS client bugfixes and cleanups
Date: Tue, 10 Jan 2012 09:47:42 -0800
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430CCB0A22@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <201201101822.21157.wolfgang.walter@stwm.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes and cleanups
Thread-Index: AczPvHCmITnc8wNfTDOC9T04k4cV+wAAktJg
References: <1326142671.9041.1.camel@lade.trondhjem.org> <201201101153.51438.wolfgang.walter@stwm.de> <1326202733.2477.32.camel@lade.trondhjem.org> <201201101822.21157.wolfgang.walter@stwm.de>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Wolfgang Walter" <wolfgang.walter@stwm.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-nfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Jan 2012 17:47:44.0147 (UTC) FILETIME=[F4E84E30:01CCCFBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0AHlv0w011983



> -----Original Message-----
> From: Wolfgang Walter [mailto:wolfgang.walter@stwm.de]
> Sent: Tuesday, January 10, 2012 12:22 PM
> To: Myklebust, Trond
> Cc: Linus Torvalds; linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [GIT PULL] Please pull NFS client bugfixes and cleanups
> 
> Am Dienstag, 10. Januar 2012 schrieb Trond Myklebust:
> > On Tue, 2012-01-10 at 11:53 +0100, Wolfgang Walter wrote:
> > > Am Dienstag, 10. Januar 2012 schrieb Trond Myklebust:
> > > > On Tue, 2012-01-10 at 01:49 +0100, Wolfgang Walter wrote:
> > > > > On Monday 09 January 2012, Trond Myklebust wrote:
> > > > > > On Mon, 2012-01-09 at 14:28 -0800, Myklebust, Trond wrote:
> > > > > > > > -----Original Message-----
> > > > > > >
> > > > > > > Please read the changelog and documentation:
> > > > > > >
> > > > > > > If your server doesnâ€™t support numeric uids/gids, then you
> > > > > > > will see _no_ change in behaviour.
> > > > >
> > > > > Hmm, what does that mean exactly? Does a linux nfs4-server
> > > > > support numeric uids/gids? If yes, by default or do I need do set an
> option?
> > > >
> > > > The patch requires no changes to a configuration that is already
> > > > working. That's the whole point I've been trying to get across.
> > >
> > > So if user foo has uid 500 on the server and uid 600 on the client
> > > that will still work with AUTH_SYS:
> > >
> > > client: uid 500 => foo@REALM
> > > server: foo@REALM => uid 600
> >
> > No. In the scenario you describe above, it will be
> 
> Sorry. Of course.
> 
> >
> > client: uid 600 <=> foo@REALM
> > server: foo@REALM <=> uid 500
> >
> > > and vice-versa?
> >
> > The above _not_ work properly in the existing code... This kind of
> > situation is the whole reason for wanting to change the existing code.
> >
> > With the existing code, the client will send numeric uid 600 as part
> > of the rpc-level AUTH_SYS authentication, and so the server will
> > create files with uid 600 irrespective of the foo@REALM idmapping at
> > the NFSv4 level.
> > When the client later attempts to do a GETATTR on that file, the
> > server will then translate that uid 600 using the idmapper
> >
> > server  uid 600 => bar@REALM
> > client  bar@REALM => uid 213412
> >
> > IOW: This is exactly the situation where we want to use numeric uids
> > everywhere, so that the server returns a numeric uid 600 in the GETATTR.
> > In addition, if the client does a 'chown foo', it should send uid 600
> > in the SETATTR request, which matches the uid 600 in the AUTH_SYS
> > authentication.
> 
> We are using AUTH_SYS for exporting read-only.
> 
> The uid (and gids) of the users accessing the filesystem (that is our idenitities
> used with SYS_AUTH) are synced. But there are other identities which are
> not. Debian i.e. allocates some system uids and gids dynamically.
> 
> With this change access to files and directories will not break but i.e. if you
> use cp as root cp will behave differently. I.e. as part of our installation
> process we once mounted a filesystem ro and cloned it with cp -a .... This
> would break.

You will get an exact replica of the server filesystem, just as if you had used NFSv3.

> > Or again: If I'm using AUTH_SYS, then I'm transmitting numeric
> > uids/gids as my authentication token, and so I want to use the same
> > numeric uids/gids to label my file ownership. The idmapper doesn't
> > affect the AUTH_SYS authentication token, and so mapping the NFS
> > ownership to trond@REALM is not useful and may instead result in wrong
> > behaviour such as in the situation described above.
> 
> So this basically says that idmapper will not be used for AUTH_SYS any more
> and behaves exactly as NFSv3?

Yes
-  NFSv3 got the behaviour with AUTH_SYS right, but RPCSEC_GSS is broken.
- The original NFSv4 protocol text got the behaviour with RPCSEC_GSS right, but AUTH_SYS is broken.

This change means that NFSv4 finally gets both AUTH_SYS _and_ RPCSEC_GSS right. It make the NFS protocol use principal-like names when principals are used as the basis for authentication, and numeric uid/gids when those are used as the basis for authentication. It ensures that acls and mode bit-based permissions always work as expected...

Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
