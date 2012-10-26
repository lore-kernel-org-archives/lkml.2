Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab2JZDit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:38:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53299 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2JZDir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:38:47 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVObmYD9iG1yMkCNqfdx-XxMKOJ41kAROyxx-RBDufKKmQ@mail.gmail.com>
References: <1351212379-26026-1-git-send-email-ming.lei@canonical.com>
 <CA+55aFwaLnyYFaydxw1ALmp_EP217DmgY=ihNy3z1ZqF-pqkSA@mail.gmail.com> <CACVXFVObmYD9iG1yMkCNqfdx-XxMKOJ41kAROyxx-RBDufKKmQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2012 20:38:25 -0700
X-Google-Sender-Auth: fVWJEsfShY4niplJrCRlzwiYbLM
Message-ID: <CA+55aFzoJULimHhYHdb-BW1bqSAY8FUevPnYu-K6nDa7xRtg2w@mail.gmail.com>
Subject: Re: [PATCH v1] firmware loader: introduce module parameter to
 customize fw search path
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 8:12 PM, Ming Lei <ming.lei@canonical.com> wrote:
>
> Yes, it should be the cleanest, I don't do it because I thought that might
> have caused one compile warning('const char *' points to memory
> without 'const', like below)

You can just keep the const.

In fact, you could even add one, and make it be

   static const char * const fw_path[] = {

We currently don't mark fw_path[] itself const (even though it is),
only the strings it points to.

> but in fact there isn't any warning with above change and it does work, still
> don't know why? :-(

It's valid to cast a non-const pointer to a const one. It's the
*other* way around that is invalid.

So marking fw_path[] as having 'const char *' elements just means that
we won't be changing those elements through the fw_path[] array
(correct: we only read them). The fact that one of those same pointers
is then also available through a non-const pointer variable means that
they can change through *that* pointer, but that doesn't change the
fact that fw_path[] itself contains const pointers.

Remember: in C, a "const pointer" does *not* mean that the thing it
points to cannot change. It only means that it cannot change through
*that* pointer.

           Linus
