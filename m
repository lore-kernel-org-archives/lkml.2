Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0LQSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:09:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61946 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab0LQSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:09:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=GZ5t6iVbH/wksMj26jLPKGf53O3deF8OKwk3WZZKv3/SrSQ1YcyMn9SnVl8c8lN2Cl
         IiUred1F6XSfpgcgP6CSF/HznQ3nv2vDfayV9rk68rgK0RxAZFsXGYwNhoM2t1UCsQLn
         vhEDAAOqbHQfMs/YL1gnOsyF1stqzXT5ADBRc=
MIME-Version: 1.0
In-Reply-To: <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
Date: Fri, 17 Dec 2010 10:09:54 -0800
X-Google-Sender-Auth: D3-pntWgfHJ2GlBETG4I5zLhrZo
Message-ID: <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:28 PM, Tony Luck <tony.luck@gmail.com> wrote:
>> The _only_ valid reason for persistent storage is for things like
>> oopses that kill the machine.
>
> Maybe I misunderstood what "KMSG_DUMP_OOPS" meant ... it
> looked to me like this code is used for non-fatal OOPsen - ones
> that will be logged to /var/log/messages.

Thinking about this a bit more I see my experiments with
this were hopelessly naive. There is no way to know at
"oops" time whether the problem is going to turn out to
be minor or fatal.  So the right thing to do here is assume
the worst and squirrel the data away safely just in case
death is imminent.

This means that I need to re-think this part too:
+/*
+ * Call platform driver to write a record to the
+ * persistent store. We don't worry about making
+ * this visible in the pstore filesystem as the
+ * presumption is that we only save things to the
+ * store in the dying moments of OS failure. Hence
+ * nobody will see the entries in the filesystem.
+ */

Since rumors of the death of the kernel may be greatly
exaggerated ... I *do* need to make the newly added
records visible in the pstore file system so that we
don't run into the situation where persistent store
has been filled with a series of minor oops reports
(which are in any case also logged elsewhere) with
no space left to log the fatal message. Adding
them to the file system would give the user a handle
to look at them and erase them.

> So in the end, I really don't see any point at all to this thing.

So does fixing this stupidity provide a useful point for this?

The point I see, is providing a generic layer that any platform
persistent store driver can use by just writing simple
read/write/erase functions ... rather than everyone
having to roll their own, slightly different, versions of
what could be a common interface. There was a
recent attempt to do exactly this with:
     drivers/staging/dream/pmem.c
which has currently been dropped - but it may come
back (and my version doesn't have, or need, "ioctl"
operations :-).

-Tony
