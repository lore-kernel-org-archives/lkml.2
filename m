Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975Ab1KJOm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:42:56 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40157 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934648Ab1KJOmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:42:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111110074408.GE10138@secunet.com>
References: <1320902290-19050-1-git-send-email-msb@chromium.org>
	<20111110074408.GE10138@secunet.com>
Date: Thu, 10 Nov 2011 08:42:54 -0600
Message-ID: <CABqD9hZh0yNq5FbC73qhmy3Xa-80ZygSxXAuxbcJEmJqi3K7dw@mail.gmail.com>
Subject: Re: [PATCH] dm: verity target
From: Will Drewry <wad@chromium.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 1:44 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Wed, Nov 09, 2011 at 09:18:10PM -0800, Mandeep Singh Baines wrote:
>>
>> + * TODO(wad): All hash storage memory is pre-allocated and freed once an
>> + * entire branch has been verified.
>> + */
>> +struct dm_bht {
>> +     /* Configured values */
>> +     int depth;  /* Depth of the tree including the root */
>> +     unsigned int block_count;  /* Number of blocks hashed */
>> +     unsigned int block_size;  /* Size of a hash block */
>> +     char hash_alg[CRYPTO_MAX_ALG_NAME];
>> +     unsigned char salt[DM_BHT_SALT_SIZE];
>> +
>> +     /* Computed values */
>> +     unsigned int node_count;  /* Data size (in hashes) for each entry */
>> +     unsigned int node_count_shift;  /* first bit set - 1 */
>> +     /* There is one per CPU so that verified can be simultaneous. */
>> +     struct hash_desc hash_desc[NR_CPUS];  /* Container for the hash alg */
>
> Please don't add a new user for the old hash interface. If the hashes can
> be done asynchronous you can use ahash, if not use shash. Both interfaces
> are reentrant, that's probaply what you want to have here. You don't
> need to have this in a per cpu manner.

I'll check out the two interfaces.  I didn't realize hash_desc was
deprecated specifically in favor of one of the others.  I'm interested
in seeing if it is possible to not keep a per-cpu desc though with the
other apis.  We do this now to avoid contention across multiple kernel
threads on crypto operations sharing the hash_desc (e.g., by wrapping
it in a mutex).

Thanks!
