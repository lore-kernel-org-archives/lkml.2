Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2ILDlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:41:09 -0400
Received: from tundra.namei.org ([65.99.196.166]:40792 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2ILDlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:41:06 -0400
Date: Wed, 12 Sep 2012 13:34:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Digital signature library bugfix
Message-ID: <alpine.LRH.2.02.1209121333031.4482@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply for v3.6.

The following changes since commit 0bd1189e239c76eb3a50e458548fbe7e4a5dfff1:
  Linus Torvalds (1):
        Merge branch 'for-3.6-fixes' of git://git.kernel.org/.../tj/wq

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dmitry Kasatkin (1):
      digsig: add hash size comparision on signature verification

 lib/digsig.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

commit 83e7c8fb4347186f6723f4c7d176999becbb3830
Author: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date:   Thu Sep 6 01:06:49 2012 +0300

    digsig: add hash size comparision on signature verification
    
    Commit b35e286a640f31d619a637332972498b51f3fd90 introduced the bug.
    
    When pkcs_1_v1_5_decode_emsa() returns without error and hash sizes do not
    match, hash comparision is not done and digsig_verify_rsa() returns no error.
    This is a bug and this patch fixes it.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/lib/digsig.c b/lib/digsig.c
index 286d558..77b1848 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -164,8 +164,12 @@ static int digsig_verify_rsa(struct key *key,
 
 	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
 
-	if (!err && len == hlen)
-		err = memcmp(out2, h, hlen);
+	if (err || len != hlen) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	err = memcmp(out2, h, hlen);
 
 err:
 	mpi_free(in);
