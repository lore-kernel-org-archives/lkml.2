Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab2BOSvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:51:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33212 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2BOSvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:51:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
From: Egmont Koblinger <egmont@gmail.com>
Date: Wed, 15 Feb 2012 19:50:58 +0100
Message-ID: <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
Subject: PROBLEM: Data corruption when pasting large data to terminal
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Short summary:  When pasting large amount of data (>4kB) to terminals,
often the data gets mangled.

How to reproduce:
Create a text file that contains this line about 100 times:
a=(123456789123456789123456789123456789123456789123456789123456789)
(also available at http://pastebin.com/LAH2bmaw for a while)
and then copy-paste its entire contents in one step into a "bash" or
"python" running in a graphical terminal.

Expected result: The interpreter correctly parses these lines and
produces no visible result.
Actual result: They complain about syntax error.
Reproducibility: About 10% on my computer (2.6.38.8), reportedly 100%
on friends' computers running 2.6.37 and 3.1.1.

Why I believe this is a kernel bug:
- Reproducible with any source of copy-pasting (e.g. various
terminals, graphical editors, browsers).
- Reproducible with at least five different popular graphical terminal
emulators where you paste into (xterm, gnome, kde, urxvt, putty).
- Reproducble with at least two applications (bash, python).
- stracing the terminal shows that it does indeed write the correct
copy-paste buffer into /dev/ptmx, and all its writes return the full
amount of bytes requested, i.e. no short write.
- stracing the application clearly shows that it does not receive all
the desired characters from its stdin, some are simply missing, i.e. a
read(0, "3", 1) = 1 is followed by a read(0, "\n", 1) = 1 (with a
write() and some rt_sigprocmask()s in between), although the char '3'
shouldn't be followed by a newline.
- Not reproducible on MacOS.

Additional informaiton:
- On friends' computers the bug always happens from the offset 4163
which is exactly the length of the first line (data immediately
processed by the application) plus the magic 4095. The rest of that
line, up to the next newline, is cut off.

- On my computer, the bug, if happens, always happens at an offset
behind this one; moreover, there's a lone digit '3' appearing on the
display on its own line exactly 4095 bytes before the syntax error.
Here's a "screenshot" with "$ " being the bash prompt, and with my
comments after "#":

$ a=(123456789123456789123456789123456789123456789123456789123456789)
# repeated a few, varying number of times
3
# <- notice this lone '3' on the display
$ a=(123456789123456789123456789123456789123456789123456789123456789)
# 60 times, that's 4080 bytes incl. newlines
$ a=(123456789123
> a=(123456789123456789123456789123456789123456789123456789123456789)
bash: syntax error near unexpected token `('
$ a=(123456789123456789123456789123456789123456789123456789123456789)
# a few more times

- I couldn't reproduce with cat-like applications, I have a feeling
perhaps the bug only occurs in raw terminal mode, but I'm really not
sure about this.


I'd be glad if you could find the time to look at this problem, it's
quite unfortunate that I cannot safely copy-paste large amount of data
into terminals.
Thanks a lot,
egmont
