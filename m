Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1FKLl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 07:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab1FKLl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 07:41:27 -0400
Date: Sat, 11 Jun 2011 07:41:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Connor Hansen <cmdkhh@gmail.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
        Martijn Uffing <mp3project@sarijopen.student.utwente.nl>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean finney <seanius@seanius.net>
Subject: Re: [OOPS] 3.0-rc1 cifs
Message-ID: <20110611074113.5a05f919@tlielax.poochiereds.net>
In-Reply-To: <BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
	<20110609183045.01f6f9fc@tlielax.poochiereds.net>
	<BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
	<Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
	<20110610073702.061bc014@corrin.poochiereds.net>
	<BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
	<4DF20A97.8010405@suse.de>
	<BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 05:49:46 -0700
Connor Hansen <cmdkhh@gmail.com> wrote:

> On Fri, Jun 10, 2011 at 5:14 AM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> > On 06/10/2011 05:33 PM, Connor Hansen wrote:
> >> On Fri, Jun 10, 2011 at 4:37 AM, Jeff Layton <jlayton@redhat.com> wrote:
> >>> On Fri, 10 Jun 2011 02:57:21 +0200 (CEST)
> >>>  Uffing <mp3project@sarijopen.student.utwente.nl> wrote:
> >>>
> >>>>
> >>>> <snip>
> >>>>> call in get_dfs_path()
> >>>>> rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
> >>>>>
> >>>>> function header for CIFSTCon
> >>>>> int  CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> >>>>>          const char *tree, struct cifs_tcon *tcon,
> >>>>>          const struct nls_table *nls_codepage)
> >>>>>
> >>>>> get_dfs_path() is passing struct cifs_tcon *tcon as NULL
> >>>>>
> >>>>> from config:  CONFIG_CIFS_WEAK_PW_HASH=y
> >>>>>
> >>>>> in CIFSTCon
> >>>>>
> >>>>> #ifdef CONFIG_CIFS_WEAK_PW_HASH
> >>>>> 3222                 if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
> >>>>> 3223                     (ses->server->secType == LANMAN))
> >>>>> 3224                         calc_lanman_hash(tcon->password,
> >>>>> ses->server->cryptkey,
> >>>>>
> >>>>> in calc_lanman_hash tcon is dereferenced(tcon->password) without being
> >>>>> checked if null
> >>>>>
> >>>>> 3225                                          ses->server->sec_mode &
> >>>>> 3226                                             SECMODE_PW_ENCRYPT ?
> >>>>> true : false,
> >>>>> 3227                                          bcc_ptr);
> >>>>> 3228                 else
> >>>>> 3229 #endif /* CIFS_WEAK_PW_HASH */
> >>>>>
> >>>>> Connor
> >>>>
> >>>>
> >>>> Ave all
> >>>>
> >>>> I recompiled  kernel 3.0-rc1 (hadn't enabled CONFIG_DEBUG_INFO=y) and put
> >>>> the oops (with the new adresses) through gdb per instruction of Jeff. And
> >>>> Connor was spot on!
> >>>>
> >>>> <qoute oops>
> >>>> BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
> >>>> IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
> >>>> </qoute oops>
> >>>>
> >>>> <qoute gdb>
> >>>> This GDB was configured as "x86_64-linux-gnu".
> >>>> For bug reporting instructions, please see:
> >>>> <http://www.gnu.org/software/gdb/bugs/>...
> >>>> Reading symbols from
> >>>> /lib/modules/3.0.0-rc1-debug/kernel/fs/cifs/cifs.ko...done.
> >>>> (gdb) list *(CIFSTCon+0xf6)
> >>>> 0xc2b6 is in CIFSTCon (fs/cifs/connect.c:3230).
> >>>> 3225                                             ses->server->sec_mode &
> >>>> 3226                                                SECMODE_PW_ENCRYPT ?
> >>>> true : false,
> >>>> 3227                                             bcc_ptr);
> >>>> 3228                    else
> >>>> 3229    #endif /* CIFS_WEAK_PW_HASH */
> >>>> 3230                    rc = SMBNTencrypt(tcon->password,
> >>>> ses->server->cryptkey,
> >>>> 3231                                            bcc_ptr);
> >>>> 3232
> >>>> 3233                    bcc_ptr += CIFS_AUTH_RESP_SIZE;
> >>>> 3234                    if (ses->capabilities & CAP_UNICODE) {
> >>>> (gdb)
> >>>> </qoute gdb>
> >>>>
> >>>
> >>> (cc'ing Sean F. since I suspect this regression is due to his changes)
> >>>
> >>> Thanks for the analysis, Martijn and Connor...
> >>>
> >>> What sort of server are you mounting here? It looks like it's using
> >>> share-level security, so it's either very old or is a samba server
> >>> configured that way.
> >>>
> >>> I suspect that commit c1508ca236 is the culprit. With that, we call
> >>> into expand_dfs_referral on every mount attempt. Previously we only
> >>> called into there when we got back  an EREMOTE error and that would
> >>> have been unlikely on a share-level security connection.
> >>>
> >>> I think there are several possible solutions, but since Sean was in
> >>> here most recently I'd like to have his opinion.
> >>
> >> I don't know enough about cifs but this call in fs/cifs/connect.c
> >>
> >> 2268: rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
> >>
> >> will always result in a null pointer derefence as CIFSTCon uses the
> >> cifs_tcon struct for passwords without verification
> >
> > Yes, I too was hovering around this code path today and it doesn't look
> > correct. Specifically, the call from cifs_dfs_path to CIFSTCon with
> > cifs_tcon as NULL seems wrong. I tried to do dig history a bit with `git
> > blame`, but couldn't figure out the commit that introduced this.
> >
> >
> > --
> > Suresh Jayaraman
> >
> 
> git annotate fs/cifs/connect.c
> 1da177e4        (Linus Torvalds 2005-04-16 15:20:36 -0700       2268)
>          rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
> 
> this was valid at the time to simply get the rc, and the code was checked
>  if ((rc == 0) && (tcon != NULL)) {   //  first use of tcon in
> CIFSTCon back then.....
> 
> 
> after a loooooong look, i found the patch which changed it
> 
> 00e485b0
> commit 00e485b0198ea4f509341373f1d9adb0a5977a2f
> Author: Jeff Layton <jlayton@redhat.com>
> Date:   Fri Dec 5 20:41:21 2008 -0500
> 
>     cifs: store password in tcon
> 
>     cifs: store password in tcon
> 
>     Each tcon has its own password for share-level security. Store it in
>     the tcon and wipe it clean and free it when freeing the tcon. When
>     doing the tree connect with share-level security, use the tcon password
>     instead of the session password.
> 
>     Signed-off-by: Jeff Layton <jlayton@redhat.com>
>     Signed-off-by: Steve French <sfrench@us.ibm.com>
> 

Yep, mea culpa. This patch should fix it. Martin, can you test it?
Anyone else have comments?

Thanks...

-----------------------[snip]--------------------

[PATCH] cifs: correctly handle NULL tcon pointer in CIFSTCon

Long ago (in commit 00e485b0), I added some code to handle share-level
passwords in CIFSTCon. That code ignored the fact that it's legit to
pass in a NULL tcon pointer when connecting to the IPC$ share on the
server.

This wasn't really a problem until recently as we only called CIFSTCon
this way when the server returned -EREMOTE. With the introduction of
commit c1508ca2 however, it gets called this way on every mount, causing
an oops when share-level security is in effect.

Fix this by simply treating a NULL tcon pointer as if user-level
security were in effect. I'm not aware of any servers that protect the
IPC$ share with a specific password anyway. Also, add a comment to the
top of CIFSTCon to ensure that we don't make the same mistake again.

Reported-by: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7b6cad2..fa5a5d7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3174,6 +3174,10 @@ out:
 	return rc;
 }
 
+/*
+ * Issue a TREE_CONNECT request. Note that for IPC$ shares, that the tcon
+ * pointer may be NULL.
+ */
 int
 CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	 const char *tree, struct cifs_tcon *tcon,
@@ -3208,7 +3212,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 	pSMB->AndXCommand = 0xFF;
 	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
 	bcc_ptr = &pSMB->Password[0];
-	if ((ses->server->sec_mode) & SECMODE_USER) {
+	if (!tcon || (ses->server->sec_mode & SECMODE_USER)) {
 		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
 		*bcc_ptr = 0; /* password is null byte */
 		bcc_ptr++;              /* skip password */
-- 
1.7.5.2

