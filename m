Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2BAIHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:07:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:61093 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684Ab2BAIHT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:07:19 -0500
MIME-Version: 1.0
In-Reply-To: <1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1326558605.19951.7.camel@lappy>
	<1326561043.5287.24.camel@edumazet-laptop>
	<1326632384.11711.3.camel@lappy>
	<1326648305.5287.78.camel@edumazet-laptop>
	<alpine.DEB.2.00.1201170910130.4800@router.home>
	<1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.DEB.2.00.1201170927020.4800@router.home>
	<1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Wed, 1 Feb 2012 10:07:18 +0200
X-Google-Sender-Auth: ftmppTwtBEoqt7IABQaFEUxNnyE
Message-ID: <CAOJsxLFLkQDxYq9nuM91q8DB99gSuz9DBfXktNGpS4Ss63GHdA@mail.gmail.com>
Subject: Re: Hung task when calling clone() due to netfilter/slab
From: Pekka Enberg <penberg@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>, davem <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 5:30 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 17 janvier 2012 à 09:27 -0600, Christoph Lameter a écrit :
>
>> Subject: slub: Do not hold slub_lock when calling sysfs_slab_add()
>>
>> sysfs_slab_add() calls various sysfs functions that actually may
>> end up in userspace doing all sorts of things.
>>
>> Release the slub_lock after adding the kmem_cache structure to the list.
>> At that point the address of the kmem_cache is not known so we are
>> guaranteed exlusive access to the following modifications to the
>> kmem_cache structure.
>>
>> If the sysfs_slab_add fails then reacquire the slub_lock to
>> remove the kmem_cache structure from the list.
>>
>> Reported-by: Sasha Levin <levinsasha928@gmail.com>
>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>
>> ---
>>  mm/slub.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/mm/slub.c
>> ===================================================================
>> --- linux-2.6.orig/mm/slub.c  2012-01-17 03:07:11.140010438 -0600
>> +++ linux-2.6/mm/slub.c       2012-01-17 03:26:06.799986908 -0600
>> @@ -3929,13 +3929,14 @@ struct kmem_cache *kmem_cache_create(con
>>               if (kmem_cache_open(s, n,
>>                               size, align, flags, ctor)) {
>>                       list_add(&s->list, &slab_caches);
>> +                     up_write(&slub_lock);
>>                       if (sysfs_slab_add(s)) {
>> +                             down_write(&slub_lock);
>>                               list_del(&s->list);
>>                               kfree(n);
>>                               kfree(s);
>>                               goto err;
>>                       }
>> -                     up_write(&slub_lock);
>>                       return s;
>>               }
>>               kfree(n);
>
> Thanks !
>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

I'm planning to queue this for v3.4 and tagging it for -stable for
v3.3. Do we need this for older versions as well?

                        Pekka
