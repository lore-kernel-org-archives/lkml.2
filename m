Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0JMSUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:20:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47519 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0JMSUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Fja0WTkertLX3K3gW002UmkJ6q+UbgEpt9oFWcodXnwCaCSiEZVsDe9vlgmulB524M
         //Gj1P1cCadaLSCNczbyI4waUL84wbfxnStiu7kyyeymIYdaxVFLiqAxE3u/6lXpikhv
         AMKKOnqwT5CPIL45f7yWOWrOulVC8SnZjKT4M=
MIME-Version: 1.0
Date: Wed, 13 Oct 2010 20:20:05 +0200
Message-ID: <AANLkTi=V7CRseXu1LmAYG24ajpvo+e374rzSV=OqoTVe@mail.gmail.com>
Subject: Swap over RAID1 hangs kernel
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

trying to find out, why my system hung after what should only have
been a short swap storm, I was able to reduce the testcase to only
involve the md raid1 code.

My testcase:
3 SATA drives: 1 with an XFS filesystem as /, 2 each with a 10 GB
partition that get assembled into a RAID1 as /dev/md2
Hardware is a NUMA system with 2 nodes, each node as 2GB RAM and 2 CPU cores.
After booting, I do a "swapon /dev/md2" and mount a tmpfs with size=6g

After executing the following command, the system stalls.
for ((i=0; $i<16; i=$i+1)) do (dd if=/dev/zero of=tmpfs-path/zero$i
bs=4k &) ; done


Because I was trying to find the cause of my earlier hangs, I have
instrumented mm/mempool.c to yell, if an allocation dips into the pool
and also, when an allocation gets stalled because of __GFP_WAIT
(repeat_alloc-loop in mempool_alloc()).
This instrumentation tells me, that the exhausted pool is the
fs_bio_set from fs/bio.c

As written in http://marc.info/?l=linux-kernel&m=128671179817823&w=2 I
believe the cause is, that the code in make_request() from
drivers/md/raid1.c calls bio_clone() once for each drive, and only
after allocation bios for all drives, the bios get submitted. This
allocation pattern was introduced in commit
191ea9b2c7cc3ebbe0678834ab710d7d95ad3f9a when adding the intent bitmap
code, before that change to loop over all the drives included a direct
call to generic_make_request().

I'm not sure, what the correct fix is. Should r1bio_pool be used, or
should each bio submitted immediately?

Torsten
