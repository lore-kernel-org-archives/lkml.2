Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2DBOqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:46:18 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:54284 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2DBOqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:46:17 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 95.21.41.4
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Rl1xJHBDyhrCqDv8oBVER
Date: Mon, 2 Apr 2012 16:46:11 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: linux-kernel@vger.kernel.org
Subject: Hang opening a pipe written to by a child, with SIGCHLD
Message-ID: <20120402144611.GY3029@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had troubles running a simple bash script where a child wrote to a named pipe
before dying, and the parent opened and read the pipe.

On a computer, my script hangs always. Also under 'strace'. Not under 'strace
-f'. Thinking of some race, I wrote a small script that hangs in the linuxes I
could try (3.2.11 now):

----------
#!/var/run/current-system/sw/bin/bash

PIPE=/tmp/pipe

rm -f $PIPE
mkfifo $PIPE

function spawn {
    echo DONE > $PIPE
}

spawn sleep 1 &

while true; do
    echo reading
    while read LINE < $PIPE; do
        echo $LINE
        spawn &
    done
done
-------------

bash uses SA_RESTART on SIGCHLD handler, and nevertheless the script halts at
printing some amount of 'DONE'. Strace shows it's inside the open() call, while the open
call has been interrupted by SIGCHLD. One of the computers I have hangs at the *first* DONE always, and that's why it's annoying to me.

Can anyone reproduce this?

Regards,
Lluís.
