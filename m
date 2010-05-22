Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935723Ab0EVBtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 21:49:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935712Ab0EVBtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 21:49:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=E8W3NhdO8EyxMAjGWmcboXzA7L9dRehm7cjHri2yYlvVMfK0dYOciIxOI3pap9EN2
	2yoPFU2Sg5Wls9NFzaq/g==
MIME-Version: 1.0
In-Reply-To: <31783.1274282492@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-11-git-send-email-walken@google.com>
	 <31783.1274282492@redhat.com>
Date: Fri, 21 May 2010 18:49:10 -0700
Message-ID: <AANLkTilBIZ71S2cO1NNe_30yzXdWtfkQoFcl44ktFiVb@mail.gmail.com>
Subject: Re: [PATCH 10/10] Use down_read_critical() for /sys/<pid>/exe and 
	/sys/<pid>/maps files
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 8:21 AM, David Howells <dhowells@redhat.com> wrote:
> However...  I'm not certain that giving a process that's accessing
> /proc/pid/maps priority over a second process that may be trying to do mmap or
> page fault or something internally is a good idea.
>
> It would be useful if you made clearer what you're actually measuring from
> /proc/pid/maps...

This is relatively large software; I don't actually have a complete
view of it myself.
However some of the things it does include the following:

- The cluster management software tracks ownership of sysv shm
segments, potentially deleting them if they have been abandoned.
/proc/<pid>/maps files are used as an input to these decisions.

- There is a separate module making numa aware decisions based on
/proc/<pid>/numa_maps information. This drives decisions such as
moving data between nodes (we have not been pushing the corresponding
kernel patches yet). Using down_read_critical() here would be
desirable too, but not as critical as for other parts of the system
(numa awareness is not the biggest worry when machines get under
enough memory pressure that reading numa_maps starts blocking).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
