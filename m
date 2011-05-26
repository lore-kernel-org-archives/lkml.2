Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab1EZUZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:25:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40148 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab1EZUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:25:08 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=wom5GMh1gUkA:10 a=CeA-nHI1PCoA:10 a=Rj1_iGo3bfgA:10 a=IkcTkHD0fZMA:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=DfNHnWVPAAAA:8 a=2g7al-zkAAAA:8 a=20KFwNOVAAAA:8 a=1DYln7H3HAjjbXTcpGcA:9 a=QEXdDO2ut3YA:10 a=lBRciGGoxdUA:10 a=JZonRkAYZ_cA:10 a=jEp0ucaQiEUA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 26 May 2011 15:25:05 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
        David Howells <dhowells@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Set cred->user_ns in key_replace_session_keyring
Message-ID: <20110526202505.GA6367@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this cred was not created with copy_creds(), it needs to get
initialized.  Otherwise use of syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);
can lead to a NULL deref.  Thanks to Robert for finding this.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Reported-by: Robert Święcki <robert@swiecki.net>
Cc: David Howells <dhowells@redhat.com>
---
 security/keys/process_keys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 6c0480d..92a3a5d 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -847,6 +847,7 @@ void key_replace_session_keyring(void)
 	new-> sgid	= old-> sgid;
 	new->fsgid	= old->fsgid;
 	new->user	= get_uid(old->user);
+	new->user_ns	= new->user->user_ns;
 	new->group_info	= get_group_info(old->group_info);
 
 	new->securebits	= old->securebits;
-- 
1.7.0.4

