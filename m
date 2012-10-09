Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab2JIWFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:05:32 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45238 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2JIWF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:05:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
References: <alpine.LNX.2.00.1210050032220.3873@pobox.suse.cz>
	<20121009214227.GC27882@quack.suse.cz>
Date: Tue, 09 Oct 2012 15:05:24 -0700
In-Reply-To: <20121009214227.GC27882@quack.suse.cz> (Jan Kara's message of
	"Tue, 9 Oct 2012 23:42:27 +0200")
Message-ID: <87txu32tej.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+0fO+485hCLmrA0aL8n0ENmOJsgKP1Km0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0107]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Kara <jack@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: PRJQUOTA case not handled in need_print_warning()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Fri 05-10-12 00:34:29, Jiri Kosina wrote:
>> Hi,
>> 
>> commit e8a3e4719b7ec19288c56f22623f537cb78885c1
>> Author: Eric W. Biederman <ebiederm@xmission.com>
>> Date:   Sun Sep 16 01:11:45 2012 -0700
>> 
>>     userns: Implement struct kqid
>> 
>> causes this warning:
>> 
>> fs/quota/dquot.c: In function ‘need_print_warning’:
>> fs/quota/dquot.c:1158: warning: enumeration value ‘PRJQUOTA’ not handled in switch
>> 
>> and it seems to be a valid one -- the switch in need_print_warning() 
>> contains neither 'default' nor PRJQUOTA case handler.
>   Hum, since Eric didn't seem to care, I've fixed this up myself with the
> attached patch. Actually, PRJQUOTA should never get to that function so it
> shouldn't cause any problems in practice. Thanks for the report.

Sorry about that.  I knew there was no functional regression as the
functional part of the code had not changed.  I was waiting for a my
head to have a clear moment where I could look through and see if
PRJQUOTA could ever make it there.

Having just made the time to look at it and see that this all goes
to dquot_alloc_space and is not related to the more general
quota_send_warning path I agree that in practice we will never get there
with a PRJQUOTA as xfs is the only filesystem that supports project
quotas and xfs does not call dquot_alloc_space.

If another filesytem were to support project quotas and used the dquot
infrastructure it is theoretically possible to reach need_warning
with a project quota.  But even in that theoretical case since project
quotas identifiers do not attach themselves to tasks it looks like
ignoring them is the right thing to do.

Eric

