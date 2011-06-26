Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1FZQKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab1FZQHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:07:54 -0400
Date: Sun, 26 Jun 2011 13:06:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/14] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl
 doesn't exist
Message-ID: <20110626130607.5931a2f8@pedra>
In-Reply-To: <cover.1309103285.git.mchehab@redhat.com>
References: <cover.1309103285.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, -EINVAL is used to return either when an IOCTL is not
implemented, or if the ioctl was not implemented.

Note: Drivers that don't use video_ioctl2, will need extra patches.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 8cb27f3..93722da 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -117,6 +117,7 @@ ERRORS = \
 	EPERM \
 	ERANGE \
 	EPIPE \
+	ENOIOCTLCMD \
 
 ESCAPE = \
 	-e "s/&/\\&amp;/g" \
diff --git a/Documentation/DocBook/media/v4l/func-ioctl.xml b/Documentation/DocBook/media/v4l/func-ioctl.xml
index b60fd37..0c97ba9 100644
--- a/Documentation/DocBook/media/v4l/func-ioctl.xml
+++ b/Documentation/DocBook/media/v4l/func-ioctl.xml
@@ -132,14 +132,15 @@ complete the request.</para>
 &VIDIOC-S-CTRL; ioctl to a value which is out of bounds.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENOIOCTLCMD</errorcode></term>
+	<listitem>
+	  <para>The application attempted to use a non-existent ioctl. This is returned by the V4L2 core only.
+		Applications should be able to handle this error code, in order to detect if a new ioctl is
+		not implemented at the current Kernel version. Kernel versions lower than 3.0 returns EINVAL to
+		non-existing ioctl's.</para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
-
-<!--
-Local Variables:
-mode: sgml
-sgml-parent-document: "v4l2.sgml"
-indent-tabs-mode: nil
-End:
--->
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index a7fd76d..7bac5f9 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -128,6 +128,13 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.0.0</revnumber>
+	<date>2011-06-24</date>
+	<authorinitials>mcc</authorinitials>
+	<revremark>Standardize an error code for invalid ioctl.</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>2.6.39</revnumber>
 	<date>2011-03-01</date>
 	<authorinitials>mcc, po</authorinitials>
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 213ba7d..ebdf762 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -542,12 +542,12 @@ static long __video_do_ioctl(struct file *file,
 	struct v4l2_fh *vfh = NULL;
 	struct v4l2_format f_copy;
 	int use_fh_prio = 0;
-	long ret = -EINVAL;
+	long ret = -ENOIOCTLCMD;
 
 	if (ops == NULL) {
 		printk(KERN_WARNING "videodev: \"%s\" has no ioctl_ops.\n",
 				vfd->name);
-		return -EINVAL;
+		return ret;
 	}
 
 	if ((vfd->debug & V4L2_DEBUG_IOCTL) &&
-- 
1.7.1


