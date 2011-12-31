Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1LaEzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 23:55:54 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42049 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1LaEzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 23:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <20111229162453.GC4806@moon>
References: <20111228160655.GL17712@google.com> <20111228161809.GQ27266@moon>
 <20111228162653.GM17712@google.com> <20111228164055.GR27266@moon>
 <20111228164522.GO17712@google.com> <20111228165336.GS27266@moon>
 <20111228170116.GQ17712@google.com> <20111228171419.GA19321@moon>
 <20111229142438.GI4460@moon> <20111229161414.GC3516@google.com> <20111229162453.GC4806@moon>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 30 Dec 2011 23:55:29 -0500
Message-ID: <CAGZ=bqLW7TvUESokP5Z-1bkXKidzwyGWi4_9-UyTptSxWhxKHg@mail.gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 11:24, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> +int gen_obj_id(void *ptr, int type, char *dst, unsigned long size)
> +{
> [...]
> +       unsigned long key;
> [...]
> +       BUG_ON(type >= GEN_OBJ_ID_TYPES);
> +
> +       if (unlikely(size < GEN_OBJ_ID_BUF_SIZE))
> +               return -EINVAL;
> +
> +       tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
> +       if (IS_ERR(tfm))
> +               return PTR_ERR(tfm);
> +
> +       WARN_ON_ONCE(crypto_hash_digestsize(tfm) != GEN_OBJ_ID_DIGEST_SIZE);

The issue here is "crypto_alloc_hash()" from atomic context.  Do that
during initialization when you compute the gen_obj_cookie[] array.

For the syscall prototype, something like this:

        ssize_t object_id(int obj_type, int id_type, long id, void
*buffer, size_t buffer_len);

The function would populate as many bytes of "buffer" as it needs to
store the object ID, up to "buffer_len", and it would return the total
number of bytes needed for that particular object ID (even if more
than fit in the buffer), or a negative number for an error.  That
would allow different object types to have different numbers of bytes
depending on the hash algorithm in use.  In practice, it would even
work fine if somebody implemented a program which always passed a
128-byte buffer and a constant 128, as the first 128 bytes of SHA-2
512 is at least as unique as SHA-1.

The "obj_type" would be something like "OBJECT_TYPE_FILE",
"OBJECT_TYPE_PROCESS", etc, while the "id_type" would be
"OBJECT_FROM_FD", "OBJECT_FROM_PID", "OBJECT_FROM_TID", etc.  That
would be very easy to extend in the future with new ways of looking up
object information (IE: add "OBJECT_FROM_MMAP" that takes a cast
pointer to a mapped area as "id" and looks up the file associated with
it).

A quick optimization for users is something like this:
if (!buffer_len)
        return crypto_hash_digestsize(tfm);

> [...]
> +       key = ((unsigned long)ptr) ^ gen_obj_cookie[type];
> +       sg_init_one(sg, &key, sizeof(key));

Don't XOR the key and the object cookie, you are reducing your
possible hash states.  Instead feed both together into the hash, and
make "gen_obj_cookie" an array of 8 or 16 bytes, EG:

u8 key[sizeof(void *) + sizeof(gen_obj_cookie[type])];
*(void **)key = ptr;
memcpy(key + sizeof(void *), &gen_obj_cookie[type],
sizeof(gen_obj_cookie[type]));

Even SHA-1 benefits from the massive number of additional possible
hash states that this provides over SHA1(ptr ^ cookie).  Ideally, you
should actually dynamically allocate the gen_obj_cookie data so that
the cookcie value is the same size as the hash output.  That ensures
that even if a "ptr" is always the same (IE: known-plaintext attack)
you still have to break the whole hash algorithm to compute
"gen_obj_cookie".  This makes even a partially-broken hash much
stronger against the same attacks.

> +               snprintf(dst, size,
> +                        "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
> +                        "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
> +                        tmp[ 0], tmp[ 1], tmp[ 2], tmp[ 3], tmp[ 4],
> +                        tmp[ 5], tmp[ 6], tmp[ 7], tmp[ 8], tmp[ 9],
> +                        tmp[10], tmp[11], tmp[12], tmp[13], tmp[14],
> +                        tmp[15], tmp[16], tmp[17], tmp[18], tmp[19]);

Don't hexdump the key, just return pure binary and allow the user to
encode it if they care (EG: files in "proc" would hexdump, but a
syscall would not).  Also, I somehow suspect there is a preexisting
function to do this for a byte array.

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
