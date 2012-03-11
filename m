Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2CKOBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 10:01:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46265 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab2CKOBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 10:01:42 -0400
Date: Sun, 11 Mar 2012 14:03:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 1/9] exec: add a global execve counter
Message-ID: <20120311140310.1c7c735f@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFy-ktC3NG5Wc+vhWB+18aqj9a0VLUSKQg+KR=FsVqfoJQ@mail.gmail.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
	<1331421919-15499-2-git-send-email-tixxdz@opendz.org>
	<CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
	<CA+55aFy-ktC3NG5Wc+vhWB+18aqj9a0VLUSKQg+KR=FsVqfoJQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wonder if the number part of exec_id would even have to be 64-bit. I
> think I can do about 10000 execves per second if I make the program a
> small static one - and that's on a fast CPU. And it's a per-thread
> counter, so you can't scale it with lots of CPU's. So it would take
> something like four days to wrap. Hmm..

I don't think an exec id trick works that well here. It needs to bind to
the actual *object* being used and refcount it in the cases that matter,
then have a proper way of ensuring we clean up references such as a list
of objects to zap hooked to each task struct

So something like


	struct foo_node {
		struct list_node node;
		struct proc_object *ref;
	};
		
	ref = NULL;
	if (foo->ptr != NULL
		ref = kref_get(foo->ptr);

And in the task exit paths walk the node list doing a kref_put/NULL

Add a suitable lock and it ought to be able to generically do that for
anything you need to clobber.

You've still got a sort of race however, just as the proposed execid base
code.  You can pass the fd and access the proc function *as* the exec
occurs. Assuming your ref counting is valid and you use new objects after
the exec that ought to just mean you get the data for the old mm struct,
which seems fine to me. It's logically equivalent to having asked a
microsecond before the exec rather than during it.

Alan
