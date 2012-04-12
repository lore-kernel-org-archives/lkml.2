Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277Ab2DLJLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:11:15 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50654 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762248Ab2DLJLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:11:12 -0400
MIME-Version: 1.0
From: Axel Kittenberger <axkibe@gmail.com>
Date: Thu, 12 Apr 2012 11:10:50 +0200
Message-ID: <CABg07fsLytFfv1G1O4tGEx9+g+RXKFcxqsiDvnQFiQS2mwCESg@mail.gmail.com>
Subject: Recognizing Inotify move events in pairs.
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear LKML,

I got a problem pairing inotify MOVE_FROM and MOVE_TO events. The
basic problem is, so far I assumed when the read from the inotify fd
return 0. "Nothing more", and I got a MOVE_FROM event where no
matching MOVE_TO has yet arrived, that it will not arrive, since the
file/directory has been moved outside of the directory tree I'm
watching. This has worked great for two years. However, recently I
keep getting complains from my users using kernel >= 3.0 that my
application ( Lsyncd ) does not recognize move events correctly and
assumes a move to be a file delete and a file creation instead. From
the debug logs I received the events happened like this.

* reading a MOVE_FROM from the inotify fd with cookie = 815
* reading from inotify fd returns 0  --> no more events.
--> My daemon concludes the file has been moved to somewhere it does
not watch, and behaves as it would have been deleted.
* the great pselect() fires! more events on the inotify fd.
* reading a MOVE_TO from the inotify fd with cookie = 815
--> Oops, the daemon behaved already, like it would have been a delete.

So, was I wrong in my naive assumption that when a move happens the
two inotify events will always come in one queue before the kernel
reports the queue is empty? Is there a correct way to know from a
MOVE_FROM that no matching MOVE_TO will arrive before the next inotify
event arrive (which might take a long time)? Is that actually even a
proven assumption that the matching MOVE_TO event will be the next
event?

Kind regards, Axel
