Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab0EBUrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 16:47:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0EBUrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 16:47:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Subject: possible locking bug in tty_open
Date: Sun, 2 May 2010 22:47:33 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00098-g79af6cf; KDE/4.4.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005022247.33857.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Jg/q192PxsrL19cVD6DApJ01dFFumLWgHEV9
 K/QQnZzX8yF/NEYwHPY2jvGuZ4dsaThKMlWq6Tnv9cIeEYhqKN
 60ESI7bxUGvIMckDUmZzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While playing some more with my TTY BKL patches, I stumbled over
what looks like a bug in tty_open, introduced in e8c6210 
"tty: push the BKL down into the handlers a bit":

After the "retry_open:" label, we first get the tty_mutex
and then the BKL. However a the end of tty_open, we jump
back to retry_open with the BKL still held. If we run into
this case, the tty_open function will be left with the BKL
still held.

It may be impossible to actually trigger this bug, because
the path is only taken if a tty driver open function returns
-ERESTARTSYS without setting signal_pending().

	Arnd
