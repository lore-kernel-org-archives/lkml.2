Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1HNRpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:45:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58462 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1HNRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:45:44 -0400
Message-ID: <4E4809BF.6040707@landley.net>
Date: Sun, 14 Aug 2011 12:45:35 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Artem.Bityutskiy@nokia.com,
        busybox@busybox.net
Subject: [BUG] Linux 3.0 commit 3627924acf70a broke include/mtd/ubi_user.h.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make headers_install" copies include/mtd/ubi_user.h to userspace, where
things like busybox link against it.  With 3.0, building defconfig
busybox gets this error:

In file included from miscutils/ubi_tools.c:63:
/home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:329:
error: conflicting types for '__packed'
/home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:313:
error: previous declaration of '__packed' was here

This is due to the Linux 3.0 commit in the title:

    UBI: use __packed instead of __attribute__((packed))

This relies on __packed being defined in:

  include/linux/compiler-gcc.h:
  #define __packed			__attribute__((packed))

Which is not exported to userspace.

I.E. this "cleanup" broke the ability for userspace to use this header,
even though the header is exported to userspace by headers_install.

Rob
