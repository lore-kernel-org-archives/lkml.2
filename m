Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0DWPYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:24:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42587 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab0DWPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:24:23 -0400
Date: Sat, 24 Apr 2010 00:23:19 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, security@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][BUG][TAKE2] KEYRINGS: find_keyring_by_name() can
 gain the freed keyring
Message-Id: <20100424002319.d68a3819.toshi.okajima@jp.fujitsu.com>
In-Reply-To: <10934.1272022437@redhat.com>
References: <20100423195127.48095127.toshi.okajima@jp.fujitsu.com>
	<20100422163755.355794e3.toshi.okajima@jp.fujitsu.com>
	<7894.1271931370@redhat.com>
	<20100423194547.3135efb8.toshi.okajima@jp.fujitsu.com>
	<10934.1272022437@redhat.com>
Organization: Fujitsu co.,ltd.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 12:33:57 +0100
David Howells <dhowells@redhat.com> wrote:

> Better still, atomic_inc_not_zero().  How about the attached patch?
Your fix looks good to me. But, if usage count of the keyring is 0,
I think it better to return -ENOKEY immediately. 

Like this.
> +			/* we've got a match but we might end up racing with
> +			 * key_cleanup() if the keyring is currently 'dead'
> +			 * (ie. it has a zero usage count) */
> +			if (!atomic_inc_not_zero(&keyring->usage))

> +				continue;
			=>	break;


And my previous figure description(in first patch) was a bit wrong. 
Please replace it with my new one:

[Figure Description](Example)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
|(cleaner)				(user)
| free_user(user)			sys_keyctl()
|  |                                      |
|  key_put(user->session_keyring)    keyctl_get_keyring_ID()
|  ||	//=> keyring->usage = 0        |
|  |schedule_work(&key_cleanup_task)  lookup_user_key()
|  ||                                      |
|  kmem_cache_free(,user)             |
|  .                                  |[KEY_SPEC_USER_KEYRING]
|  .                                  install_user_keyrings()
|  .                                       ||
| key_cleanup() [<= worker_thread()]  ||
|  |                                       ||
|  [spin_lock(&key_serial_lock)]      |[mutex_lock(&key_user_keyr..mutex)]
|  |                                       ||
|  atomic_read() == 0                 ||
|  |{ rb_ease(&key->serial_node,) }   ||
|  |                                       ||
|  [spin_unlock(&key_serial_lock)]    |find_keyring_by_name()
|  |                                       |||
|  keyring_destroy(keyring)           ||[read_lock(&keyring_name_lock)]
|  ||                                      |||
|  |[write_lock(&keyring_name_lock)]  ||atomic_inc(&keyring->usage)
|  |.                                 ||| *** GET freeing keyring ***
|  |.                                 ||[read_unlock(&keyring_name_lock)]
|  ||                                      ||
|  |list_del()                        |[mutex_unlock(&key_user_k..mutex)]
|  ||                                      |
|  |[write_unlock(&keyring_name_lock)] ** INVALID keyring is returned **
|  |                                        .
|  kmem_cache_free(,keyring)           .
|                                           . 
|                                      atomic_dec(&keyring->usage)
v                                         *** DESTROYED ***
TIME 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

Best Regards, 
Toshiyuki Okajima
