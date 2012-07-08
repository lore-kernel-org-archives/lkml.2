Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2GHNGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 09:06:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2GHNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 09:06:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120708135911.69fe9566@pyramind.ukuu.org.uk>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
 <20120706175501.GA11908@kroah.com> <CAPXgP11Om4T-U6e-uZVYsV0FcJtkgnMfa+v94R46v=xdbhm77w@mail.gmail.com>
 <20120708135911.69fe9566@pyramind.ukuu.org.uk>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 8 Jul 2012 15:06:20 +0200
Message-ID: <CAPXgP11LwEdCg=iySj55mjV5=am-6rjx8VdasAFDU97AeH3iPg@mail.gmail.com>
Subject: Re: Bug 44211 - /proc/kmsg does not (always) block for 1-byte reads
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Jukka Ollila <jiiksteri@gmail.com>,
        linux-kernel@vger.kernel.org, jbeulich@novell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 8, 2012 at 2:59 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The patch will not fix the underlying problem, but just make it behave
>> more like it was and allow partial message reads. This is a years old
>> problem, the net is full of bugreports of stuff going wrong with
>> running dd bs=1 on /proc/kmsg. It is a really stupid idea, and can not
>> work for many other reasons too. The interface can not safely be used
>> that way, it does not have the usual semantics, it always returned 0
>> for read() whenever it needed to.
>
> If you are breaking the semantics perhaps that should also get fixed ?

I hopefully just restored the old semantics now.

Fixing it properly would be a bigger code change, and it can't use the
far-too-simple tunneling through the syslog() syscall to feed
/proc/kmsg.

If the seq_file interface could be used, that would probably be the
best option, but I have no good idea how to make blocking reads, and
concurrent non-blocks work with the seq_file stuff.

This is how read() in /proc/kmsg works and it is not protected by a
lock or anything, and there is a not too small window between the
check and the action. Things just go wrong if there is more than a
single reader, but that was the case since forever.

static ssize_t kmsg_read(struct file *file, char __user *buf,
                         size_t count, loff_t *ppos)
{
        if ((file->f_flags & O_NONBLOCK) &&
            !do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
                return -EAGAIN;
        return do_syslog(SYSLOG_ACTION_READ, buf, count, SYSLOG_FROM_FILE);
}

Thanks,
Kay
