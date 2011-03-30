Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab1C3MR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:17:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34630 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab1C3MRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XpqT95y6bAB1xHD1UDdIqCypGr18HflHt9Wdo6egzERHZ2fSz44PrBjg160/0qJSoe
         zLZp8QjNL7k1PrcxLnYyIZqOS1Nils1vB0VlWcH5MEfsbOi3Tz9KEvgifGlXcyKM/A0w
         XruQygAaBQZxd7MB3FrmbgQDLgw+b4iHEKpEA=
MIME-Version: 1.0
In-Reply-To: <1301485085.29074.61.camel@e102109-lin.cambridge.arm.com>
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
	<AANLkTi=vcn5jHpk0O8XS9XJ8s5k-mCnzUwu70mFTx4=g@mail.gmail.com>
	<1301485085.29074.61.camel@e102109-lin.cambridge.arm.com>
Date: Wed, 30 Mar 2011 13:17:24 +0100
Message-ID: <AANLkTikXfVNkyFE2MpW9ZtfX2G=QKvT7kvEuDE-YE5xO@mail.gmail.com>
Subject: Re: kmemleak for MIPS
From: Maxin John <maxin.john@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>, naveen yadav <yad.naveen@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick observation from dmesg after placing printks in
"net/ipv4/udp.c" for MIPS-malta

CONFIG_BASE_SMALL : 0
table->mask : 127
UDP_HTABLE_SIZE_MIN :  256

dmesg:
....
...
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
CONFIG_BASE_SMALL : 0
UDP hash table entries: 128 (order: 0, 4096 bytes)
table->mask, UDP_HTABLE_SIZE_MIN : 127 256
CONFIG_BASE_SMALL : 0
UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)
table->mask, UDP_HTABLE_SIZE_MIN : 127 256
NET: Registered protocol family 1
....
....

printk(s) are placed in udp.c as listed below:

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 588f47a..ca7f6c6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2162,7 +2162,7 @@ __setup("uhash_entries=", set_uhash_entries);
 void __init udp_table_init(struct udp_table *table, const char *name)
 {
        unsigned int i;
-
+       printk("CONFIG_BASE_SMALL : %d \n", CONFIG_BASE_SMALL);
        if (!CONFIG_BASE_SMALL)
                table->hash = alloc_large_system_hash(name,
                        2 * sizeof(struct udp_hslot),
@@ -2175,6 +2175,8 @@ void __init udp_table_init(struct udp_table
*table, const char *name)
        /*
         * Make sure hash table has the minimum size
         */
+       printk("table->mask, UDP_HTABLE_SIZE_MIN : %d %d
\n",table->mask,UDP_HTABLE_SIZE_MIN);
+
        if (CONFIG_BASE_SMALL || table->mask < UDP_HTABLE_SIZE_MIN - 1) {
                table->hash = kmalloc(UDP_HTABLE_SIZE_MIN *
                                      2 * sizeof(struct udp_hslot), GFP_KERNEL);
~


Best Regards,
Maxin
