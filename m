Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2HOUbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:31:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57769 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab2HOTtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: tglx@linutronix.de, mingo@redhat.com, davem@davemloft.net, hpa@zytor.com,
        thierry.reding@avionic-design.de, bfields@redhat.com,
        eric.dumazet@gmail.com, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, viro@zeniv.linux.org.uk,
        gorcunov@openvz.org, akpm@linux-foundation.org,
        tim.c.chen@linux.intel.com, devel@openvz.org
References: <20120815161141.7598.16682.stgit@localhost.localdomain>
Date: Wed, 15 Aug 2012 12:49:28 -0700
In-Reply-To: <20120815161141.7598.16682.stgit@localhost.localdomain>
	(Stanislav Kinsbursky's message of "Wed, 15 Aug 2012 20:21:56 +0400")
Message-ID: <87a9xwc4vr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19zDb7FJMmAnNa/DCiWOlTlkZ5eADmB70Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 0/5] net: socket bind to file descriptor introduced
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> This patch set introduces new socket operation and new system call:
> sys_fbind(), which allows to bind socket to opened file.
> File to bind to can be created by sys_mknod(S_IFSOCK) and opened by
> open(O_PATH).
>
> This system call is especially required for UNIX sockets, which has name
> lenght limitation.
>
> The following series implements...

Thinking about this a little more I have serious reservations about this
approach.

Today you are not allowed to bind to an address unless mknod for that
file succeeds.  Your patch totally changes those semantics.

Name length limitation does not seeme to justify this at all.

It is possible today to trivially change into a directory and
bind or connect to what would be a long absolute path.

There is also the trick of getting a shorter directory name using
/proc/self/fd if you are threaded and can't change the directory.

The obvious choices at this point are
- Teach bind and connect and af_unix sockets to take longer AF_UNIX
  socket path names.

- introduce sockaddr_fd that can be applied to AF_UNIX sockets,
  and teach unix_bind and unix_connect how to deal with a second type of sockaddr.
  struct sockaddr_fd { short fd_family; short pad; int fd; };

- introduce sockaddr_unix_at that takes a directory file descriptor
  as well as a unix path, and teach unix_bind and unix_connect to deal with a
  second sockaddr type.
  struct sockaddr_unix_at { short family; short pad; int dfd; char path[102]; }
  AF_UNIX_AT

I don't know what the implications of for breaking connect up into 3
system calls and changing the semantics are and I would really rather
not have to think about it.

But it certainly does not look to me like you introduce new systems
calls to do what you want.

Eric

