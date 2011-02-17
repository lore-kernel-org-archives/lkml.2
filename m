Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab1BQUE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:04:27 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:54634 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1BQUEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=from
	:content-type:content-transfer-encoding:subject:date:message-id
	:to:mime-version; q=dns; s=dreamhost.com; b=dTDAwLgqFJ+uSfD0vwnK
	IUd/XyLG7bBxK4hZXtPvzzTydSqu7ZARkS+VeNBKQI/mNA4o9iUOV85X638w04V/
	IEiEdKNywXdXRXTlF2qiFFKEZ8l20znG6yvWWLW/FelGih1gYDkVSKavr8Ucs2N5
	4DLVelE7kzXfY0nmOsd0LUI=
From: Andrew Farmer <andrew.farmer@dreamhost.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH/RFC] Treat CR like NL in script interpreter line
Date: Thu, 17 Feb 2011 12:04:19 -0800
Message-Id: <1F59539A-FC19-4FB0-A6E1-51A6F62C7B63@dreamhost.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command-line or CGI scripts with CR+LF line ending end up confusing
binfmt_script. This typically ends up making the scripts fail to run with
inexplicable error messages (like "no such file or directory"). While it'd
certainly be ideal to just tell users to use sensible text editors, making
their scripts just work as intended is nice too.

When a similar patch was proposed in 2001, the issue was raised that it would
prevent the operation of a script using the "perl\r" interpreter, for instance.
However, not only is this a very silly interpreter name, but it's also already
impossible to use an interpreter with a tab, space, or newline in its name, and
I don't believe anyone's complained about those inabilities!

---
 fs/binfmt_script.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 396a988..b19c001 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -36,7 +36,7 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
        bprm->file = NULL;
 
        bprm->buf[BINPRM_BUF_SIZE - 1] = '\0';
-       if ((cp = strchr(bprm->buf, '\n')) == NULL)
+       if ((cp = strpbrk(bprm->buf, "\n\r")) == NULL)
                cp = bprm->buf+BINPRM_BUF_SIZE-1;
        *cp = '\0';
        while (cp > bprm->buf) {
-- 
1.7.1.1
