Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab0EFDNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 23:13:17 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65106 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0EFDNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 23:13:16 -0400
Message-Id: <201005060312.o463CUOQ085547@www262.sakura.ne.jp>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: xiaosuo@gmail.com
Cc: eric.dumazet@gmail.com, jslaby@suse.cz, viro@zeniv.linux.org.uk,
       paulmck@linux.vnet.ibm.com, adobriyan@gmail.com, mingo@elte.hu,
       peterz@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 06 May 2010 12:12:30 +0900
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
In-Reply-To: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05052010 #3818610, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
> struct kvfree_work_struct {
> 	struct work_struct	work;
> 	void			*head;
> 	void			**ptail;
> };

I wonder why "struct kvfree_work_struct" is needed.
According to http://kernel.ubuntu.com/git?p=jj/ubuntu-lucid.git;a=blobdiff;f=security/apparmor/match.c;h=d2cd55419acfcae85cb748c8f837a4384a3a0d29;hp=afc2dd2260edffcf88521ae86458ad03aa8ea12c;hb=f5eba4b0a01cc671affa429ba1512b6de7caeb5b;hpb=abdff9ddaf2644d0f9962490f73e030806ba90d3 ,

static void kvfree_work(struct work_struct *work)
{
	vfree(work);
}

void kvfree_inatomic(void *ptr, size_t size)
{
	if (size < PAGE_SIZE) {
		kfree(ptr);
	} else if (is_vmalloc_addr(ptr)) {
		/*
		 * We can embed "struct work_struct" inside *ptr
		 * because size >= PAGE_SIZE.
		 */
		struct work_struct *work = ptr;
		BUILD_BUG_ON(sizeof(struct work_struct) > PAGE_SIZE);
		INIT_WORK(&work, kvfree_work);
		schedule_work(&work);
	} else {
		free_pages_exact(ptr, size);
	}
}

should do what you want. (Though, I didn't test it.)
