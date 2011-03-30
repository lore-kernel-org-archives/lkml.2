Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1C3LZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:25:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46201 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab1C3LZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=njPFbiRNGMz636OF67g0+2gYNeqGnRbZ7G98CRdQCMGMTEfn2Xq/328T529/bC1DQ6
         Z8BU9XE5vpcrpMXQevjeWEjsF928YMxhG894Pxx5Wm2afcd+nQgAzF/DIfsk5NWgc/UT
         AJ/IAdL1ffJyzYlmfboOxa7+43Kxu3s4FoIbA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=L0zqwQ869khH1efFUghGeJjoyTaBXs-O2icaM@mail.gmail.com>
References: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
	<AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
	<1300960540.32158.13.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim139fpJsMJFLiyUYvFgGMz-Ljgd_yDrks-tqhE@mail.gmail.com>
	<1301395206.583.53.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim-4v5Cbp6+wHoXjgKXoS0axk1cgQ5AHF_zot80@mail.gmail.com>
	<1301399454.583.66.camel@e102109-lin.cambridge.arm.com>
	<AANLkTin0_gT0E3=oGyfMwk+1quqonYBExeN9a3=v=Lob@mail.gmail.com>
	<AANLkTi=gMP6jQuQFovfsOX=7p-SSnwXoVLO_DVEpV63h@mail.gmail.com>
	<1301476505.29074.47.camel@e102109-lin.cambridge.arm.com>
	<AANLkTi=YB+nBG7BYuuU+rB9TC-BbWcJ6mVfkxq0iUype@mail.gmail.com>
	<AANLkTi=L0zqwQ869khH1efFUghGeJjoyTaBXs-O2icaM@mail.gmail.com>
Date: Wed, 30 Mar 2011 14:24:59 +0300
X-Google-Sender-Auth: KvC7MfIQxgX5fOuinasIvjaV3t0
Message-ID: <AANLkTi=vcn5jHpk0O8XS9XJ8s5k-mCnzUwu70mFTx4=g@mail.gmail.com>
Subject: Re: kmemleak for MIPS
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Maxin John <maxin.john@gmail.com>
Cc: naveen yadav <yad.naveen@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have:

> UDP hash table entries: 128 (order: 0, 4096 bytes)
> CONFIG_BASE_SMALL=0

udp_table_init looks like:

        if (!CONFIG_BASE_SMALL)
                table->hash = alloc_large_system_hash(name, .. &table->mask);
        /*
         * Make sure hash table has the minimum size
         */

Since CONFIG_BASE_SMALL is 0, we are allocating the hash using
alloc_large_system
Then:
        if (CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1) {
                table->hash = kmalloc();

table->mask is 127, and UDP_HTABLE_SIZE_MIN is 256, so we are allocating again
table->hash without freeing already allocated memory.

We could free table->hash, before allocating the memory with kmalloc.
I don't fully understand the condition table->mask < UDP_HTABLE_SIZE_MIN - 1.

Eric?

thanks,
Daniel.
