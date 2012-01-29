Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2A2OSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 09:18:00 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34034 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2A2OR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 09:17:59 -0500
Date: Sun, 29 Jan 2012 14:19:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Bryan Jacobs <its@easytoremember.us>, linux-kernel@vger.kernel.org
Subject: Re: /proc/[pid]/mem write implications
Message-ID: <20120129141920.497d96d4@pyramind.ukuu.org.uk>
In-Reply-To: <4F24BEB5.5070402@gmail.com>
References: <20120128203250.090abec6@easytoremember.us>
	<4F24BEB5.5070402@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But I think that allowing arbitrary processes to write to **their own**
> > memory via a file descriptor might in itself be problematic. Please,
> > help me understand how this is safe.
> 
> You will have a sysctl to control if it is writable.

The problem is not that the check is done in write, the problem is more
fundamental - the open should bind to the memory of the executable image
currently running, instead it effectively late binds each write to the
image now being run. That is the root cause.

What's sad about this is that people went and re-introduced the bug and
clearly didn't think to spend 2 minutes asking Google why the checks were
there originally.

2006 thread

http://lkml.indiana.edu/hypermail/linux/kernel/0605.2/1359.html

2004 thread

http://lkml.indiana.edu/hypermail/linux/kernel/0407.0/1169.html

2002 thread

http://www.eros-os.org/pipermail/cap-talk/2002-May/000922.html


If you really want to fix this then you need to bind /proc/self/mem to
the executable image in question, and you need to effectively revoke()
that on exec so it can't be used to pin old images into memory.

Fix that and the rest falls out in the wash.

Alan
