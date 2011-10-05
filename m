Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab1JECnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 22:43:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63457 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab1JECnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 22:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <CADLM8XNiaxLFRZXs4NKJmoORvED-DV0bNxPF6eHsfnLqtxw09w@mail.gmail.com>
References: <CADLM8XNiaxLFRZXs4NKJmoORvED-DV0bNxPF6eHsfnLqtxw09w@mail.gmail.com>
Date: Wed, 5 Oct 2011 10:42:59 +0800
Message-ID: <CADLM8XPjxvrRFCZ6fL_+W_qX4mn+Hkg-VQRxMG9_Mch+xTDP0g@mail.gmail.com>
Subject: One comment on the __release_region in kernel/resource.c
From: Wei Yang <weiyang.kernel@gmail.com>
To: linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to resend this message, since my previous letter contains html format.

Dear experts,

I am viewing the source code of __release_region() in kernel/resource.c.
And I have one comment for the performance issue.

For example, we have a resource tree like this.
10-89
   20-79
       30-49
       55-59
       60-64
       65-69
   80-89
100-279

If the caller wants to release a region of [50,59], the original code will
execute four times in the for loop in the subtree of 20-79.

After changing the code below, it will execute two times instead.

By using the "git annotate", I see this code is committed by Linus as the
initial version. So don't get more information about why this code is written
in this way.

Maybe the case I thought will not happen in the real world?

Your comment is warmly welcome. :)

diff --git a/kernel/resource.c b/kernel/resource.c
index 8461aea..81525b4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -931,7 +931,7 @@ void __release_region(struct resource *parent,
resource_size_t start,
       for (;;) {
               struct resource *res = *p;

-               if (!res)
+               if (!res || res->start > start)
                       break;
               if (res->start <= start && res->end >= end) {
                       if (!(res->flags & IORESOURCE_BUSY)) {


-- 
Wei Yang
Help You, Help Me
