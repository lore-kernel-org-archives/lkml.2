Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2JBGae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:30:34 -0400
Received: from ozlabs.org ([203.10.76.45]:50845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab2JBGac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:30:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
In-Reply-To: <29451.1348903010@warthog.procyon.org.uk>
References: <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk> <29451.1348903010@warthog.procyon.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 02 Oct 2012 15:42:31 +0930
Message-ID: <874nmd4d2o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> I noticed the Cert number didn't change with rebuilds: "distclean"
>> didn't remove some files:
>> 
>> $ git clean -f -f -x -d
>> Removing extra_certificates
>> Removing signing_key.priv
>> Removing signing_key.x509
>> Removing signing_key.x509.keyid
>> Removing signing_key.x509.signer
>> Removing x509.genkey
>
> I'm not sure whether distclean should remove those, since they can be
> externally supplied, or whether x509.genkey should have a Makefile dependency
> on kernel/Makefile.
>
> I lean towards 'yes' when I'm altering kernel/Makefile trying to get things
> right, and 'no' when I'm doing a make distclean to change my config or
> changing kernel/Makefile for some unrelated reason.

Right.  I think we need to use different names for generated vs supplied
files, then, because 'distclean' really must delete generated files.

But it turns out you do try to clean these files, it just doesn't work.
See below.  I've applied this, as well, to my tree:

        git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git modules-next

BTW, you missed a Signed-off-by: on your "MODSIGN: Use the same digest
for the autogen key sig as for the module sig" patch.  Please update.

Cheers,
Rusty.

>From 8921e2ede91f93dcdbd08fa6613f8458de5f8afe Mon Sep 17 00:00:00 2001
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 2 Oct 2012 14:35:24 +0930
Subject: [PATCH] MODSIGN: Make mrproper should remove generated files.

It doesn't, because the clean targets don't include kernel/Makefile, and
because two files were missing from the list.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/Makefile b/Makefile
index 1c88ec3..e70ebfe 100644
--- a/Makefile
+++ b/Makefile
@@ -995,7 +995,10 @@ MRPROPER_DIRS  += include/config usr/include include/generated          \
                   arch/*/include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
-		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
+		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
+		  signing_key.priv signing_key.x509 x509.genkey		\
+		  extra_certificates signing_key.x509.keyid		\
+		  signing_key.x509.signer
 
 # clean - Delete most, but leave enough to build external modules
 #
diff --git a/kernel/Makefile b/kernel/Makefile
index 86336c9..bb94783 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -216,4 +216,3 @@ x509.genkey:
 	@echo >>x509.genkey "subjectKeyIdentifier=hash"
 	@echo >>x509.genkey "authorityKeyIdentifier=keyid"
 endif
-CLEAN_FILES += signing_key.priv signing_key.x509 x509.genkey extra_certificates


