Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2AVTBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:01:35 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:42580
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057Ab2AVTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:01:33 -0500
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bh8275dhz2fhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT004.namprd06.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F1C5D01.3060403@ixiacom.com>
Date: Sun, 22 Jan 2012 11:01:21 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Fix seq_file mishandling of consecutive pread() invocations.
References: <4F166FC9.8030906@ixiacom.com>
In-Reply-To: <4F166FC9.8030906@ixiacom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: SN2PRD0602HT004.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Rules-Execution-History: Support - Juniper
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN2PRD0602HT004.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Maintainers; Added reference to bugzilla.kernel.org in commit log ]

Also reported in:

    https://bugzilla.kernel.org/show_bug.cgi?id=11856

The following program illustrates the problem:

    char buf[8192];

    int fd = open("/proc/self/maps", O_RDONLY);

    n = pread(fd, buf, sizeof(buf), 0);
    printf("%d\n", n);

    /* lseek(fd, 0, SEEK_CUR); */ /* Uncomment to work around */

    n = pread(fd, buf, sizeof(buf), 0);
    printf("%d\n", n);

The second printf() prints zero, but uncommenting the lseek()
corrects its behaviour.

To fix, make seq_read() mirror seq_lseek() when processing changes in *ppos.
Restore m->version first, then if required traverse and update read_pos
on success.

Signed-off-by: Earl Chew <echew@ixiacom.com>
---
 fs/seq_file.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index dba43c3..7a45306 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -140,9 +140,21 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 
 	mutex_lock(&m->lock);
 
+	/*
+	 * seq_file->op->..m_start/m_stop/m_next may do special actions
+	 * or optimisations based on the file->f_version, so we want to
+	 * pass the file->f_version to those methods.
+	 *
+	 * seq_file->version is just copy of f_version, and seq_file
+	 * methods can treat it simply as file version.
+	 * It is copied in first and copied out after all operations.
+	 * It is convenient to have it as  part of structure to avoid the
+	 * need of passing another argument to all the seq_file methods.
+	 */
+	m->version = file->f_version;
+
 	/* Don't assume *ppos is where we left it */
 	if (unlikely(*ppos != m->read_pos)) {
-		m->read_pos = *ppos;
 		while ((err = traverse(m, *ppos)) == -EAGAIN)
 			;
 		if (err) {
@@ -152,21 +164,11 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 			m->index = 0;
 			m->count = 0;
 			goto Done;
+		} else {
+			m->read_pos = *ppos;
 		}
 	}
 
-	/*
-	 * seq_file->op->..m_start/m_stop/m_next may do special actions
-	 * or optimisations based on the file->f_version, so we want to
-	 * pass the file->f_version to those methods.
-	 *
-	 * seq_file->version is just copy of f_version, and seq_file
-	 * methods can treat it simply as file version.
-	 * It is copied in first and copied out after all operations.
-	 * It is convenient to have it as  part of structure to avoid the
-	 * need of passing another argument to all the seq_file methods.
-	 */
-	m->version = file->f_version;
 	/* grab buffer if we didn't have one */
 	if (!m->buf) {
 		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
-- 
1.7.0.4


