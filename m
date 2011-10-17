Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1JQOsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:48:14 -0400
Received: from re04.intra2net.com ([82.165.46.26]:54704 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1JQOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:48:13 -0400
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [slabinfo PATCH v2] Fix off-by-one buffer corruption after readlink() call
Date: Mon, 17 Oct 2011 16:48:10 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-97.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
        linux-kernel@vger.kernel.org
References: <4E9869B4.6080702@intra2net.com> <alpine.DEB.2.00.1110141252480.24783@chino.kir.corp.google.com> <CAOJsxLGS519114eonOWbDTwO+CL_e=buiW7XdbtxfCUpYz=Y6A@mail.gmail.com>
In-Reply-To: <CAOJsxLGS519114eonOWbDTwO+CL_e=buiW7XdbtxfCUpYz=Y6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171648.11074.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readlink() never zero terminates the provided buffer.
Therefore we already do

    buffer[count] = 0;

This leads to an off-by-one buffer corruption as readlink()
might return the full size of the buffer.

The common technique is to reduce the buffer size by one.
Another fix would be to check

"
if (count < 0 || count == sizeof(buffer))
    fatal();
"

Reducing the buffer size by one is easier IMHO.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
---
 tools/slub/slabinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/slub/slabinfo.c b/tools/slub/slabinfo.c
index 868cc93..cc1a378 100644
--- a/tools/slub/slabinfo.c
+++ b/tools/slub/slabinfo.c
@@ -1145,7 +1145,7 @@ static void read_slab_dir(void)
 		switch (de->d_type) {
 		   case DT_LNK:
 			alias->name = strdup(de->d_name);
-			count = readlink(de->d_name, buffer, sizeof(buffer));
+			count = readlink(de->d_name, buffer, sizeof(buffer)-1);
 
 			if (count < 0)
 				fatal("Cannot read symlink %s\n", de->d_name);
-- 
1.7.6.4
