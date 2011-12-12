Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1LLXMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:12:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63852 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1LLXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:12:33 -0500
Date: Tue, 13 Dec 2011 02:12:22 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: npiggin@kernel.dk, viro@zeniv.linux.org.uk
Cc: torvalds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: implement even faster dentry memcmp
Message-ID: <20111212231222.GA3493@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is followup to commit 9d55c369bb5e695e629bc35cba2ef607755b3bee
aka "fs: implement faster dentry memcmp".

1) use unsigned int lengths
   We'll do 4GB dentry support later, remove REX prefixes on x86_64 meanwhile.
   Switch all lengths do "unsigned int" while I'm at it.

2) dentry_cmp is only used in boolean context, so reuse comparison result
   by not returing 1 always.

3) return bool not int (my apologies)
   gcc starts to use SETNE to do quick conversion to bool

There is statistically significant "git-diff" speed up as measured on
Core i5 760. Cycle count drops by 1% which is well beyond 3-sigma 0.24%.

"perf stat", "objdump" and "size fs/dcache.o" outputs are below.

Please, benchmark on your boxes!

==============================================================================================

$ PAGER= perf stat -r 256 git-diff

 Performance counter stats for 'git-diff' (256 runs):

         41.570088 task-clock                #    0.989 CPUs utilized            ( +-  0.08% )
                 0 context-switches          #    0.000 M/sec                    ( +- 31.06% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 34.87% )
             2,298 page-faults               #    0.055 M/sec                    ( +-  0.00% )
       138,333,329 cycles                    #    3.328 GHz                      ( +-  0.08% )
        47,614,306 stalled-cycles-frontend   #   34.42% frontend cycles idle     ( +-  0.23% )
        19,397,726 stalled-cycles-backend    #   14.02% backend  cycles idle     ( +-  0.53% )
       216,543,677 instructions              #    1.57  insns per cycle
                                             #    0.22  stalled cycles per insn  ( +-  0.00% )
        28,133,169 branches                  #  676.765 M/sec                    ( +-  0.00% )
           376,548 branch-misses             #    1.34% of all branches          ( +-  0.09% )

       0.042012163 seconds time elapsed                                          ( +-  0.08% )
----------------------------------------------------------------------------------------------
$ PAGER= perf stat -r 256 git-diff

 Performance counter stats for 'git-diff' (256 runs):

         41.095011 task-clock                #    0.989 CPUs utilized            ( +-  0.08% )
                 0 context-switches          #    0.000 M/sec                    ( +- 26.04% )
                 0 CPU-migrations            #    0.000 M/sec                    ( +- 32.24% )
             2,258 page-faults               #    0.055 M/sec                    ( +-  0.00% )
       136,918,811 cycles                    #    3.332 GHz                      ( +-  0.07% )
        46,847,134 stalled-cycles-frontend   #   34.22% frontend cycles idle     ( +-  0.20% )
        19,681,660 stalled-cycles-backend    #   14.37% backend  cycles idle     ( +-  0.42% )
       214,074,343 instructions              #    1.56  insns per cycle
                                             #    0.22  stalled cycles per insn  ( +-  0.00% )
        28,064,491 branches                  #  682.917 M/sec                    ( +-  0.00% )
           368,690 branch-misses             #    1.31% of all branches          ( +-  0.08% )

       0.041550952 seconds time elapsed                                          ( +-  0.08% )

==============================================================================================

Standalone function assembly before and after the patch (MCORE2=y):

0000000000000000 <dentry_cmp>:
   0:	55                   	push   %rbp
   1:	b8 01 00 00 00       	mov    $0x1,%eax
   6:	48 89 e5             	mov    %rsp,%rbp
   9:	48 39 ce             	cmp    %rcx,%rsi
   c:	74 08                	je     16 <dentry_cmp+0x16>
   e:	c9                   	leaveq 
   f:	c3                   	retq   
  10:	48 ff c7             	inc    %rdi
  13:	48 ff c2             	inc    %rdx
  16:	0f b6 02             	movzbl (%rdx),%eax
  19:	38 07                	cmp    %al,(%rdi)
  1b:	75 13                	jne    30 <dentry_cmp+0x30>
  1d:	48 ff c9             	dec    %rcx
  20:	75 ee                	jne    10 <dentry_cmp+0x10>
  22:	31 c0                	xor    %eax,%eax
  24:	c9                   	leaveq 
  25:	c3                   	retq   
  26:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  2d:	00 00 00 
  30:	b8 01 00 00 00       	mov    $0x1,%eax
  35:	c9                   	leaveq 
  36:	c3                   	retq   
-----------------------------------------------------------
0000000000000000 <dentry_cmp>:
   0:	55                   	push   %rbp
   1:	39 ce                	cmp    %ecx,%esi
   3:	48 89 e5             	mov    %rsp,%rbp
   6:	74 0e                	je     16 <dentry_cmp+0x16>
   8:	0f 95 c0             	setne  %al
   b:	c9                   	leaveq 
   c:	c3                   	retq   
   d:	0f 1f 00             	nopl   (%rax)
  10:	48 ff c7             	inc    %rdi
  13:	48 ff c2             	inc    %rdx
  16:	0f b6 07             	movzbl (%rdi),%eax
  19:	38 02                	cmp    %al,(%rdx)
  1b:	0f 95 c0             	setne  %al
  1e:	84 c0                	test   %al,%al
  20:	75 e9                	jne    b <dentry_cmp+0xb>
  22:	ff c9                	dec    %ecx
  24:	75 ea                	jne    10 <dentry_cmp+0x10>
  26:	c9                   	leaveq 
  27:	c3                   	retq   

==============================================================================================

$ size dcache-000.o dcache-001.o 
   text    data     bss     dec     hex filename
  17907     206       2   18115    46c3 dcache-000.o
  17891     206       2   18099    46b3 dcache-001.o

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/dcache.c            |    6 +++---
 include/linux/dcache.h |   11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1381,7 +1381,7 @@ static struct dentry *__d_instantiate_unique(struct dentry *entry,
 					     struct inode *inode)
 {
 	struct dentry *alias;
-	int len = entry->d_name.len;
+	unsigned int len = entry->d_name.len;
 	const char *name = entry->d_name.name;
 	unsigned int hash = entry->d_name.hash;
 
@@ -1739,7 +1739,7 @@ struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
 	hlist_bl_for_each_entry_rcu(dentry, node, b, d_hash) {
 		struct inode *i;
 		const char *tname;
-		int tlen;
+		unsigned int tlen;
 
 		if (dentry->d_name.hash != hash)
 			continue;
@@ -1858,7 +1858,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 	
 	hlist_bl_for_each_entry_rcu(dentry, node, b, d_hash) {
 		const char *tname;
-		int tlen;
+		unsigned int tlen;
 
 		if (dentry->d_name.hash != hash)
 			continue;
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -51,14 +51,15 @@ extern struct dentry_stat_t dentry_stat;
  * Compare 2 name strings, return 0 if they match, otherwise non-zero.
  * The strings are both count bytes long, and count is non-zero.
  */
-static inline int dentry_cmp(const unsigned char *cs, size_t scount,
-				const unsigned char *ct, size_t tcount)
+static inline bool dentry_cmp(const unsigned char *cs, unsigned int scount,
+			      const unsigned char *ct, unsigned int tcount)
 {
-	int ret;
+	bool ret;
+
 	if (scount != tcount)
-		return 1;
+		return scount - tcount;
 	do {
-		ret = (*cs != *ct);
+		ret = (signed char)*cs - (signed char)*ct;
 		if (ret)
 			break;
 		cs++;
