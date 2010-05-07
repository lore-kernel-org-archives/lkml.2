Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab0EGJim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:38:42 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:47814 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab0EGJik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:38:40 -0400
X-Greylist: delayed 824 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 05:38:40 EDT
Message-ID: <4BE3DC60.7080105@control.lth.se>
Date: Fri, 07 May 2010 11:24:48 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: fanotify issues in 2.6.34-rc6-next-20100506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have started to have a look at the fanotify system, based on information
gleaned from:

  [1] http://people.redhat.com/~eparis/fanotify/
  [2] http://lwn.net/Articles/360955/

Unfortunately there seems to be some bug in the current implemenation, since
running a patched version of the fanotify.c application found in [1]

--- fanotify.c.orig     2010-03-27 05:26:27.000000000 +0100
+++ fanotify.c  2010-05-07 10:56:38.000000000 +0200
@@ -125,7 +125,7 @@
                fan_mask |= FAN_ALL_PERM_EVENTS;

        // fanotify_init(flags, event_f_flags, priority)
-       fan_fd = fanotify_init(0, O_RDONLY | O_LARGEFILE, 0);
+       fan_fd = fanotify_init(0, 0, 0);
        if (fan_fd < 0)
                goto fail;

seems to lose/corrupt events. For instance running 'fanotify -c /dir/to/watch'
and then running the command 'cd /dir/to/watch ; touch a b c d e f g h i j k l'
 might generate (results are more or less random):

/dir/to/watch/a: pid=18584 open
/dir/to/watch/a: pid=18584 close(writable)
/dir/to/watch/b: pid=18584 open                 # 2 open events for b
/dir/to/watch/b: pid=18584 open close(writable) #
/dir/to/watch/d: pid=18584 open                 # events for c missing
/dir/to/watch/d: pid=18584 open close(writable) # 2 open events for d
/dir/to/watch/f: pid=18584 open close(writable) # events for e missing
/dir/to/watch/g: pid=18584 open close(writable)
/dir/to/watch/h: pid=18584 open close(writable)
/dir/to/watch/i: pid=18584 open close(writable)
/dir/to/watch/j: pid=18584 open
/dir/to/watch/j: pid=18584 close(writable)
/dir/to/watch/k: pid=18584 open
/dir/to/watch/k: pid=18584 open close(writable) # 2 open events for k
/dir/to/watch/l: pid=18584 close(writable)      # no open event for l

A similar program using inotify gets all events correctly.


I have also problems with the fact that the following sequence dosn't leave a
trace in the fanotify events:

  mkdir /dir/not/watched
  touch /dir/not/watched/z
  ln /dir/not/watched/z /dir/to/watch/z
  rm /dir/not/watched/z
  rmdir /dir/not/watched)

What is the rationale for not reporting link/unlink events via fanotify?

Best regards

Anders Blomdell

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden
