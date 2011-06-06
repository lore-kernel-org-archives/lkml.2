Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab1FFS2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:28:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59769 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1FFS16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gyDEEvGxOjsFXz4O2WBnndPa3y8x/cELRlwXnXL/rPYt13LO/KOXLmIicP8jMigVj4
         H+qCaKC9jg1Lb+TpSidQAGytvA8I653lf52cAP3YlntirncH30V5axBhGaks8fdI0SPV
         ppCVAsFjBbB/Qm+bq6ZMqK3vD/DbvWkrCJxNc=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307384634.2497.736.camel@laptop>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <1307379926.2322.219.camel@twins>
	 <1307380297.3098.74.camel@edumazet-laptop>
	 <1307384634.2497.736.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 20:27:51 +0200
Message-ID: <1307384871.3098.98.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 20:23 +0200, Peter Zijlstra a écrit :

> 
> That's really not the point, what do we do when the COW happens during
> the FUTEX_WAIT? At that point the process vaddr changes mapping and we
> cannot continue the wait on the old page, since that would expose
> invisible information, nor can we switch to the new page since we queued
> on the old page.
> 
> Therefore we have to force the COW and queue on the private copy, it
> really is the only semi sane semantic.

The point is we dont necessarly have to COW the page. If you attempt
this COW, you shoot on user that did not expect to have a COW.

Take this program : COW is not allowed, still this worked on 2.6.18 (it
waits until another process change the value in file and call
futex_wait())

Using PROT_READ | PROT_WRITE instead of PROT_READ was OK too.

(If we use PROT_READ | PROT_WRITE, then after your patch, program doesnt
work anymore since this process gets a private page after your hidden
COW : It'll wait forever)

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
typedef uint32_t u32;   // for futex.h
#include <linux/futex.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>


int main(int argc, char *argv[]) {
 	int fd, *futex, rc, val = 42;

	fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
	write(fd, &val, 4);
	futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
	rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, 0, 0, 0);
	printf("rc=%d errno=%d\n", rc, errno);
}



