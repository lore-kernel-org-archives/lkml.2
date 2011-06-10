Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1FJMtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:49:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62263 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab1FJMtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gbf3jofqNIeCvFNuFt3+WqdbK2eMtc5kOyFNOgMK+edgI40s72m769hw4KgyKZU82d
         j19XViBgs+Q5+YpdiFpBjudo6tKSddpw8/n9+X1wifwr6Pe3vAItgcl37e5h5jMKEFqj
         8P6MAcswPR/Ni8oJE7q89EfBARIAWNYSjn/wc=
MIME-Version: 1.0
In-Reply-To: <4DF20A97.8010405@suse.de>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
	<20110609183045.01f6f9fc@tlielax.poochiereds.net>
	<BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
	<Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
	<20110610073702.061bc014@corrin.poochiereds.net>
	<BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
	<4DF20A97.8010405@suse.de>
Date: Fri, 10 Jun 2011 05:49:46 -0700
Message-ID: <BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
Subject: Re: [OOPS] 3.0-rc1 cifs
From: Connor Hansen <cmdkhh@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Jeff Layton <jlayton@redhat.com>,
        Martijn Uffing <mp3project@sarijopen.student.utwente.nl>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean finney <seanius@seanius.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 5:14 AM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> On 06/10/2011 05:33 PM, Connor Hansen wrote:
>> On Fri, Jun 10, 2011 at 4:37 AM, Jeff Layton <jlayton@redhat.com> wrote:
>>> On Fri, 10 Jun 2011 02:57:21 +0200 (CEST)
>>>  Uffing <mp3project@sarijopen.student.utwente.nl> wrote:
>>>
>>>>
>>>> <snip>
>>>>> call in get_dfs_path()
>>>>> rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
>>>>>
>>>>> function header for CIFSTCon
>>>>> int  CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>>>>>          const char *tree, struct cifs_tcon *tcon,
>>>>>          const struct nls_table *nls_codepage)
>>>>>
>>>>> get_dfs_path() is passing struct cifs_tcon *tcon as NULL
>>>>>
>>>>> from config:  CONFIG_CIFS_WEAK_PW_HASH=y
>>>>>
>>>>> in CIFSTCon
>>>>>
>>>>> #ifdef CONFIG_CIFS_WEAK_PW_HASH
>>>>> 3222                 if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
>>>>> 3223                     (ses->server->secType == LANMAN))
>>>>> 3224                         calc_lanman_hash(tcon->password,
>>>>> ses->server->cryptkey,
>>>>>
>>>>> in calc_lanman_hash tcon is dereferenced(tcon->password) without being
>>>>> checked if null
>>>>>
>>>>> 3225                                          ses->server->sec_mode &
>>>>> 3226                                             SECMODE_PW_ENCRYPT ?
>>>>> true : false,
>>>>> 3227                                          bcc_ptr);
>>>>> 3228                 else
>>>>> 3229 #endif /* CIFS_WEAK_PW_HASH */
>>>>>
>>>>> Connor
>>>>
>>>>
>>>> Ave all
>>>>
>>>> I recompiled  kernel 3.0-rc1 (hadn't enabled CONFIG_DEBUG_INFO=y) and put
>>>> the oops (with the new adresses) through gdb per instruction of Jeff. And
>>>> Connor was spot on!
>>>>
>>>> <qoute oops>
>>>> BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
>>>> IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
>>>> </qoute oops>
>>>>
>>>> <qoute gdb>
>>>> This GDB was configured as "x86_64-linux-gnu".
>>>> For bug reporting instructions, please see:
>>>> <http://www.gnu.org/software/gdb/bugs/>...
>>>> Reading symbols from
>>>> /lib/modules/3.0.0-rc1-debug/kernel/fs/cifs/cifs.ko...done.
>>>> (gdb) list *(CIFSTCon+0xf6)
>>>> 0xc2b6 is in CIFSTCon (fs/cifs/connect.c:3230).
>>>> 3225                                             ses->server->sec_mode &
>>>> 3226                                                SECMODE_PW_ENCRYPT ?
>>>> true : false,
>>>> 3227                                             bcc_ptr);
>>>> 3228                    else
>>>> 3229    #endif /* CIFS_WEAK_PW_HASH */
>>>> 3230                    rc = SMBNTencrypt(tcon->password,
>>>> ses->server->cryptkey,
>>>> 3231                                            bcc_ptr);
>>>> 3232
>>>> 3233                    bcc_ptr += CIFS_AUTH_RESP_SIZE;
>>>> 3234                    if (ses->capabilities & CAP_UNICODE) {
>>>> (gdb)
>>>> </qoute gdb>
>>>>
>>>
>>> (cc'ing Sean F. since I suspect this regression is due to his changes)
>>>
>>> Thanks for the analysis, Martijn and Connor...
>>>
>>> What sort of server are you mounting here? It looks like it's using
>>> share-level security, so it's either very old or is a samba server
>>> configured that way.
>>>
>>> I suspect that commit c1508ca236 is the culprit. With that, we call
>>> into expand_dfs_referral on every mount attempt. Previously we only
>>> called into there when we got back  an EREMOTE error and that would
>>> have been unlikely on a share-level security connection.
>>>
>>> I think there are several possible solutions, but since Sean was in
>>> here most recently I'd like to have his opinion.
>>
>> I don't know enough about cifs but this call in fs/cifs/connect.c
>>
>> 2268: rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
>>
>> will always result in a null pointer derefence as CIFSTCon uses the
>> cifs_tcon struct for passwords without verification
>
> Yes, I too was hovering around this code path today and it doesn't look
> correct. Specifically, the call from cifs_dfs_path to CIFSTCon with
> cifs_tcon as NULL seems wrong. I tried to do dig history a bit with `git
> blame`, but couldn't figure out the commit that introduced this.
>
>
> --
> Suresh Jayaraman
>

git annotate fs/cifs/connect.c
1da177e4        (Linus Torvalds 2005-04-16 15:20:36 -0700       2268)
         rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);

this was valid at the time to simply get the rc, and the code was checked
 if ((rc == 0) && (tcon != NULL)) {   //  first use of tcon in
CIFSTCon back then.....


after a loooooong look, i found the patch which changed it

00e485b0
commit 00e485b0198ea4f509341373f1d9adb0a5977a2f
Author: Jeff Layton <jlayton@redhat.com>
Date:   Fri Dec 5 20:41:21 2008 -0500

    cifs: store password in tcon

    cifs: store password in tcon

    Each tcon has its own password for share-level security. Store it in
    the tcon and wipe it clean and free it when freeing the tcon. When
    doing the tree connect with share-level security, use the tcon password
    instead of the session password.

    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

........................
-                       (ses->server->secType == LANMAN))
-                       calc_lanman_hash(ses->password, ses->server->cryptKey,
+                   (ses->server->secType == LANMAN))
+                       calc_lanman_hash(tcon->password, ses->server->cryptKey,
.........................
-               SMBNTencrypt(ses->password,
-                            ses->server->cryptKey,
+               SMBNTencrypt(tcon->password, ses->server->cryptKey,

So can probably just grab the tcon from the session in get_dfs_path and pass
it instead of the null

Connor
