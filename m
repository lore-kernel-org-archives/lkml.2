Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2JOTjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:39:54 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51653 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2JOTjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:39:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        dhowells@redhat.com, manfred@colorfullife.com, hughd@google.com,
        jmorris@namei.org, mtk.manpages@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, paulmck@linux.vnet.ibm.com,
        sds@tycho.nsa.gov, devel@openvz.org, a.p.zijlstra@chello.nl,
        cmetcalf@tilera.com, linux-driver@qlogic.com, ron.mercer@qlogic.com,
        viro@zeniv.linux.org.uk, eparis@parisplace.org, tglx@linutronix.de,
        jitendra.kalsaria@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        casey@schaufler-ca.com
References: <20121015155800.28348.23561.stgit@localhost.localdomain>
	<20121015155946.28348.47885.stgit@localhost.localdomain>
Date: Mon, 15 Oct 2012 12:39:31 -0700
In-Reply-To: <20121015155946.28348.47885.stgit@localhost.localdomain>
	(Stanislav Kinsbursky's message of "Mon, 15 Oct 2012 19:59:46 +0400")
Message-ID: <87lif7frt8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+CdQRFvSEej6DqPGT0JC5h1baRw2cTCzw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v6 02/10] ipc: "use key as id" functionality for resource get system call introduced
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> This patch introduces new IPC resource get request flag IPC_PRESET, which
> should be interpreted as a request to try to allocate IPC slot with number,
> starting from value resented by key. IOW, kernel will try
> allocate new segment in specified slot.
>
> Note: if desired slot is not emply, then next free slot will be used.

This way of handling things is pretty nasty.

- You don't fail if the requested id is not available.
- You don't allow assigning the key (which leads to the need to change
  the key in later patches).  Changing the creator uid and creator
  gid and key is semantically ugly.

It would be much cleaner if you could instead add IPC_PRESET and then
extend the definition of the creation functions all by one argument.

aka
int msgget(key_t key, int msgflg, int id);
int semget(key_t key, int nsems, int semflg, int id);
int shmget(key_t key, size_t size, int shmflg, int id);

Where the extra id argument is ignored unless IPC_PRESET is specified.

Also msgget, semget, and shmget should fail if unregconized flags are
passed in.  That ipcget doesn't do that today is bizarre.

Eric
