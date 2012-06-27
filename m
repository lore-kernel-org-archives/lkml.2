Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2F0TH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab2F0THZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:07:25 -0400
Date: Wed, 27 Jun 2012 21:05:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/4] task_work: kill task_work->data
Message-ID: <20120627190510.GA25956@redhat.com>
References: <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com> <20120627183828.GE23086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627183828.GE23086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Oleg Nesterov wrote:
>
> Turn cred->rcu into rcu_head/task_work union for keyctl_session_to_parent().

I tried to make the minimal patch, but perhaps with this change we
can also simplify the error handling in keyctl_session_to_parent()
a little bit.

We can do cred_alloc_blank() before lookup_user_key() and remove
error_keyring/key_ref_put.

IOW, on top of this patch:

--- x/security/keys/keyctl.c
+++ x/security/keys/keyctl.c
@@ -1461,17 +1461,18 @@ long keyctl_session_to_parent(void)
 	struct cred *cred;
 	int ret;
 
-	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
-	if (IS_ERR(keyring_r))
-		return PTR_ERR(keyring_r);
-
 	/* our parent is going to need a new cred struct, a new tgcred struct
 	 * and new security data, so we allocate them here to prevent ENOMEM in
 	 * our parent */
-	ret = -ENOMEM;
 	cred = cred_alloc_blank();
 	if (!cred)
-		goto error_keyring;
+		return -ENOMEM;
+
+	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
+	if (IS_ERR(keyring_r)) {
+		ret = PTR_ERR(keyring_r);
+		goto free_cred;
+	}
 
 	cred->tgcred->session_keyring = key_ref_to_ptr(keyring_r);
 	init_task_work(&cred->twork, key_change_session_keyring);
@@ -1532,13 +1533,10 @@ unlock:
 
 	if (oldwork)
 		put_cred(container_of(oldwork, struct cred, twork));
+free_cred:
 	if (cred)
 		put_cred(cred);
 	return ret;
-
-error_keyring:
-	key_ref_put(keyring_r);
-	return ret;
 }
 
 /*

