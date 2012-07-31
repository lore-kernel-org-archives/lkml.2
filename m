Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2GaOjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:39:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56411 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2GaOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:39:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
References: <20120731130314.24441.85882.stgit@ltc137.sdl.hitachi.co.jp>
	<5498.1343743325@warthog.procyon.org.uk>
Date: Tue, 31 Jul 2012 07:38:58 -0700
In-Reply-To: <5498.1343743325@warthog.procyon.org.uk> (David Howells's message
	of "Tue, 31 Jul 2012 15:02:05 +0100")
Message-ID: <874nooc7wd.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/otIqThw9eqa/bwdBPAW6MD3SRKMEZCo8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0076]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Howells <dhowells@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: fix improper indication of integer sysctl parameter
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:
>
>> When we read the sysctl parameter, they are always treated
>> as signed integer, and are casted into unsigned long type
>> in the current kernel. If we set a value equivalent to
>> (the maximum value in signed integer + 1)
>
> Wouldn't it be better to return EINVAL or EDOM?

Yes we should definitely fail the write in the case where we write an
unsigned value and we can not fit that value in an integer.

There will still remain the bug of reading the integer
where (-val == val) && val < 0.  In that case we do want to an
(unsigned int) before storing it in an unsinged long.

The decription of the patch is confusing.

The problem is not the cast to unsigned long, the problem is
the implicit cast to signed long which happens before the cast
to unsigned long.  I think this is a case where C's casting rules
get it wrong.  If I have an explicit cast why add an implicit
cast to do sign extension.  Sigh.

Mitsuo since you are looking at this do you think you could fix the
write side of the problem as well, and check to make cetain the
unsigned value we write will fit in an interger.

Eric
