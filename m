Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0H3V2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:28:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57512 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab0H3V2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=U3oA3p5n7GJwWAvBexNycT3K8pwy6cIm5UeKTTJk6jDlzjnOPhrznI26dyQYqwJWbl
         1JV3ax2nkKJ2E3lUaNhtW/i1qrJit2wGlcQinmA29Q6Tgl/xtEuMEVmunBcCPQe/2xmH
         7b3ArIm6suC/pNBqiTDuZQzh7k2dp+smUGJ/A=
MIME-Version: 1.0
Date: Mon, 30 Aug 2010 23:28:21 +0200
X-Google-Sender-Auth: q-OJNTw2VW29rev7UBNuFWeNxZc
Message-ID: <AANLkTi=4k0tc2ofwU0XLUn6Az3FhXrTex_EK4Ny-vJVM@mail.gmail.com>
Subject: (arch_)get_unmapped_area can be terribly slow due to unnecessary
 linear search and find_vma
From: Luca Barbieri <luca@luca-barbieri.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sending copy of bug #17531 since the BTS seemingly can't/won't send it to LKML]

Currently most/all versions of get_unmapped_area perform a linear search in the
process virtual address space to find free space.

Some, like arch_get_unmapped_area_topdown for x86-64 even call find_vma for
each step, which does a full walk on the rb-tree of vmas.

Instead, they should use, from slower to faster:
- O(n) but faster: a linked list of virtual address space holes
- O(log(n)): an rb-tree of virtual address space holes indexed by size
- O(1): a buddy allocator of virtual address space holes, or another scheme
with buckets

Is there any reason this issue hasn't been fixed yet? (i.e. any reason none of
the proposed schemes are feasible?)

Workloads doing a lot of mmaps tend to suffer greatly, especially on the
versions that do a find_vma for each step of the scan.

An example are OpenGL drivers using DRM/GEM/TTM who don't employ userspace
caching and suballocation of TTM allocated buffers.
