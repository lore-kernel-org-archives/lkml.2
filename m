Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1L2QZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:25:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44697 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1L2QY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:24:59 -0500
Date: Thu, 29 Dec 2011 20:24:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111229162453.GC4806@moon>
References: <20111228160655.GL17712@google.com>
 <20111228161809.GQ27266@moon>
 <20111228162653.GM17712@google.com>
 <20111228164055.GR27266@moon>
 <20111228164522.GO17712@google.com>
 <20111228165336.GS27266@moon>
 <20111228170116.GQ17712@google.com>
 <20111228171419.GA19321@moon>
 <20111229142438.GI4460@moon>
 <20111229161414.GC3516@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111229161414.GC3516@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 08:14:14AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 29, 2011 at 06:24:38PM +0400, Cyrill Gorcunov wrote:
> > Tejun, I've tried to use crypto engine here but it produced a warning
> > about being used in non-sleepable context (which takes place when we
> > read /proc/<pid>/fdinfo/* files). So I used lib/sha1.c instead. The
> > final result is below, please review.
> 
> I don't know anything about cryptography and have no idea whether sha1
> is good enough, so I can't really say much. :)
> 
> Which part triggered the context warning?  IIRC, crypto context
> preparation and actual calculation can be done in separate steps.
> Can't the calculation part be done from non-sleepable context?
> 
> cc'ing Herbert & David and quoting the whole message.
> 

I've got the following warning when being calculated sha hash
for "cat /proc/self/fdinfo/0" as following

[root@localhost ~]# cat /proc/self/fdinfo/0
[   89.120366] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[   89.123316] in_atomic(): 1, irqs_disabled(): 0, pid: 2395, name: cat
[   89.125324] 1 lock held by cat/2395:
[   89.125935]  #0:  (&(&newf->file_lock)->rlock){+.+...}, at: [<ffffffff8127a57a>] proc_fd_info+0x98/0x1f8
[   89.127647] Pid: 2395, comm: cat Not tainted 3.2.0-rc6+ #281
[   89.128615] Call Trace:
[   89.129056]  [<ffffffff810b824e>] __might_sleep+0x17c/0x188
[   89.129995]  [<ffffffff82058ba2>] down_read+0x2d/0xcc
[   89.130874]  [<ffffffff810859fd>] ? kvm_clock_read+0x54/0x9f
[   89.131856]  [<ffffffff814079ef>] crypto_alg_lookup+0x2a/0x68
[   89.132867]  [<ffffffff81407b51>] crypto_larval_lookup+0x4f/0x1c4
[   89.133951]  [<ffffffff81407cf7>] crypto_alg_mod_lookup+0x31/0xba
[   89.135020]  [<ffffffff81407fc6>] crypto_alloc_base+0x3d/0xd9
[   89.135994]  [<ffffffff81117eac>] ? __lock_acquire+0x7c1/0x1486
[   89.137025]  [<ffffffff81201a88>] gen_obj_id+0x7c/0x288
[   89.137912]  [<ffffffff8105ce40>] ? sched_clock+0x10/0x1b
[   89.138844]  [<ffffffff811031f8>] ? sched_clock_local+0x15/0xb9
[   89.139854]  [<ffffffff810f3b5d>] ? get_pid_task+0x5f/0x70
[   89.140798]  [<ffffffff8110345f>] ? sched_clock_cpu+0x137/0x154
[   89.141820]  [<ffffffff8127a57a>] ? proc_fd_info+0x98/0x1f8
[   89.142788]  [<ffffffff811160f3>] ? lock_acquired+0x2ed/0x30e
[   89.143773]  [<ffffffff8127a62d>] proc_fd_info+0x14b/0x1f8
[   89.144716]  [<ffffffff8127a729>] proc_fdinfo_read+0x4f/0xaf
[   89.145687]  [<ffffffff81204c8a>] vfs_read+0xe6/0x163
[   89.146549]  [<ffffffff81206981>] ? fget_light+0x41/0xf9
[   89.147465]  [<ffffffff81204d69>] sys_read+0x62/0x97
[   89.148342]  [<ffffffff82063b02>] system_call_fastpath+0x16/0x1b
pos:    0
flags:  0100002
id:     8db6cbf5ffede35133f633dc492e71fae28f3b8c

the helper routine was like (note it was a draft version)

+int gen_obj_id(void *ptr, int type, char *dst, unsigned long size)
+{
+	__u8 tmp[GEN_OBJ_ID_DIGEST_SIZE];
+	struct crypto_hash *tfm;
+	struct scatterlist sg[1];
+	struct hash_desc desc;
+	unsigned long key;
+	int err = 0;
+
+	BUG_ON(type >= GEN_OBJ_ID_TYPES);
+
+	if (unlikely(size < GEN_OBJ_ID_BUF_SIZE))
+               return -EINVAL;
+
+	tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+               return PTR_ERR(tfm);
+
+	WARN_ON_ONCE(crypto_hash_digestsize(tfm) != GEN_OBJ_ID_DIGEST_SIZE);
+
+	desc.tfm = tfm;
+	desc.flags = 0;
+
+	key = ((unsigned long)ptr) ^ gen_obj_cookie[type];
+	sg_init_one(sg, &key, sizeof(key));
+
+	err = crypto_hash_init(&desc);
+	if (!err)
+               err = crypto_hash_update(&desc, sg, sizeof(key));
+	if (!err)
+               err = crypto_hash_final(&desc, tmp);
+	crypto_free_hash(tfm);
+	if (!err)
+               snprintf(dst, size,
+                        "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
+                        "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
+                        tmp[ 0], tmp[ 1], tmp[ 2], tmp[ 3], tmp[ 4],
+                        tmp[ 5], tmp[ 6], tmp[ 7], tmp[ 8], tmp[ 9],
+                        tmp[10], tmp[11], tmp[12], tmp[13], tmp[14],
+                        tmp[15], tmp[16], tmp[17], tmp[18], tmp[19]);
+
+	return err;
+}

Probably I've had to crypto_alloc_hash earlier and simply keep a reference
to algo but since I'm not sure if looking for modules in late-init-call
is good idea.

	Cyrill
