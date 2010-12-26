Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab0LZTOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 14:14:00 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17386 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0LZTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 14:13:59 -0500
Date: Sun, 26 Dec 2010 20:04:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-kernel@vger.kernel.org, Will Dyson <will_dyson@pobox.com>,
        Makoto Kato <m_kato@ga2.so-net.ne.jp>,
        "Sergey S. Kostyliov" <rathamahata@php4.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] befs: Don't pass huge structs by value.
In-Reply-To: <AANLkTinOD=ovyk5CdBeJf7e0cPeGP_WUE=ZFArWrvBe2@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1012262003320.20797@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012252020000.10759@swampdragon.chaosbits.net> <AANLkTinOD=ovyk5CdBeJf7e0cPeGP_WUE=ZFArWrvBe2@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-636688503-1293390260=:20797"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-636688503-1293390260=:20797
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 26 Dec 2010, Geert Uytterhoeven wrote:

> On Sat, Dec 25, 2010 at 20:27, Jesper Juhl <jj@chaosbits.net> wrote:
> > 'struct befs_disk_data_stream' is huge (~144 bytes) and it's being passed
> > by value in fs/befs/endian.h::cpu_to_fsrun().
> >
> > It seems to me that it would be better to pass a pointer, no?
> > This patch changes the function to take a pointer to the large struct.
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  endian.h   |   16 ++++++++--------
> >  linuxvfs.c |    2 +-
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> >  Compile tested only. I have no way to test this.
> >
> > diff --git a/fs/befs/endian.h b/fs/befs/endian.h
> > index 6cb84d8..a99caa0 100644
> > --- a/fs/befs/endian.h
> > +++ b/fs/befs/endian.h
> > @@ -102,22 +102,22 @@ cpu_to_fsrun(const struct super_block *sb, befs_block_run n)
> >  }
> >
> >  static inline befs_data_stream
> > -fsds_to_cpu(const struct super_block *sb, befs_disk_data_stream n)
> > +fsds_to_cpu(const struct super_block *sb, befs_disk_data_stream *n)
> 
> Please make befs_disk_data_stream const, so people don't accidentally modify it.
> 
Certainly.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 endian.h   |   16 ++++++++--------
 linuxvfs.c |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/befs/endian.h b/fs/befs/endian.h
index 6cb84d8..2722387 100644
--- a/fs/befs/endian.h
+++ b/fs/befs/endian.h
@@ -102,22 +102,22 @@ cpu_to_fsrun(const struct super_block *sb, befs_block_run n)
 }
 
 static inline befs_data_stream
-fsds_to_cpu(const struct super_block *sb, befs_disk_data_stream n)
+fsds_to_cpu(const struct super_block *sb, const befs_disk_data_stream *n)
 {
 	befs_data_stream data;
 	int i;
 
 	for (i = 0; i < BEFS_NUM_DIRECT_BLOCKS; ++i)
-		data.direct[i] = fsrun_to_cpu(sb, n.direct[i]);
+		data.direct[i] = fsrun_to_cpu(sb, n->direct[i]);
 
-	data.max_direct_range = fs64_to_cpu(sb, n.max_direct_range);
-	data.indirect = fsrun_to_cpu(sb, n.indirect);
-	data.max_indirect_range = fs64_to_cpu(sb, n.max_indirect_range);
-	data.double_indirect = fsrun_to_cpu(sb, n.double_indirect);
+	data.max_direct_range = fs64_to_cpu(sb, n->max_direct_range);
+	data.indirect = fsrun_to_cpu(sb, n->indirect);
+	data.max_indirect_range = fs64_to_cpu(sb, n->max_indirect_range);
+	data.double_indirect = fsrun_to_cpu(sb, n->double_indirect);
 	data.max_double_indirect_range = fs64_to_cpu(sb,
-						     n.
+						     n->
 						     max_double_indirect_range);
-	data.size = fs64_to_cpu(sb, n.size);
+	data.size = fs64_to_cpu(sb, n->size);
 
 	return data;
 }
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index aa4e7c7..d5fbc09 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -384,7 +384,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 		int num_blks;
 
 		befs_ino->i_data.ds =
-		    fsds_to_cpu(sb, raw_inode->data.datastream);
+		    fsds_to_cpu(sb, &raw_inode->data.datastream);
 
 		num_blks = befs_count_blocks(sb, &befs_ino->i_data.ds);
 		inode->i_blocks =


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-636688503-1293390260=:20797--
