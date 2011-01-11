Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1AKQwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:52:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395Ab1AKQwf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <1294763679.2435.72.camel@doink>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 08:51:42 -0800
Message-ID: <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
To: aelder@sgi.com
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 8:34 AM, Alex Elder <aelder@sgi.com> wrote:
>
> FYI, when using this code, as merged by Linus, I hit the
> BUG_ON() at the beginning of d_set_d_op() when it's called
> by autofs4_dir_mkdir().  I managed to work around it by
> just commenting out those BUG_ON() calls but it's something
> that ought to get addressed properly.

Yeah, removing the BUG_ON() isn't the right thing to do - it means
that autofs4 is obviously setting the dentry ops twice for the same
dentry.

Possibly the thing could be relaxed to allow setting the _same_ d_op
pointer, ie do something like

   if (dentry->d_op == op)
      return;

at the top of that function. But looking at it, I don't think that
fixes the autofs4 issue.

The fact that autofs4 does "d_add()" before it sets the d_ops (or
other dentry state, for that matter) looks a bit scary. To me that
smells like it might get a  dentry lookup hit before it's actually
fully done.

Does it make any difference if you move the various d_add() calls down
to the end of the functions to when the "dentry" has really been
instantiated?

                      Linus
