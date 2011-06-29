Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab1F2UKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:10:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757273Ab1F2UKR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:10:17 -0400
MIME-Version: 1.0
In-Reply-To: <1308917362-4795-1-git-send-email-segoon@openwall.com>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Jun 2011 13:09:24 -0700
Message-ID: <BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
Subject: Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Vasiliy Kulikov <segoon@openwall.com>, Shailabh Nagar <nagar@us.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Solar Designer <solar@openwall.com>, Eric Paris <eparis@redhat.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 5:09 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> taskstats information may be used for gathering private information.
> E.g. for openssh and vsftpd daemons read_characters/write_characters may
> be used to learn the precise password length.  Restrict it to processes
> being able to ptrace the target process.

Ok, having looked at this some more, I'm quite ready to just mark the
whole TASKSTATS config option as BROKEN. It does seem to be a horrible
security hazard, and very little seems to use it.

It also seems to be really fundamentally broken. Afaik, there's no way
to filter taskstats not only by security issues (Vasiliy's patch
really is very ugly), but it seems to be some global cross-namespace
thing too, so it exposes taskstats across pid namespaces afaik. It
does that even with Vasiliy's patch, afaik, although then I think you
need to have collissions in the namespaces if I read the code
correctly.

I suspect that could be fixed by adding a pid namespace to the
'listener' structure. Also adding a 'cred' pointer (or the actual
listener thread pointer) to it would make Vasiliy's patch more
palatable, since then you wouldn't need to look up the credentials at
send_cpu_listeners() time.

Maybe I have mis-read the code. But it does all make me shudder. There
doesn't even seem to be all that many _users_ of the thing, so the
problems it has really makes me go "is that code worth it"? We
probably should never have merged it in the first place.

                         Linus
