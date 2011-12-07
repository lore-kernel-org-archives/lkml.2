Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1LGMWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:22:05 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42859 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1LGMWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:22:02 -0500
Message-ID: <4EDF5A58.6060905@linux.vnet.ibm.com>
Date: Wed, 07 Dec 2011 17:51:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: gregkh@suse.de, dhowells@redhat.com, eparis@redhat.com, rjw@sisk.pl,
        kay.sievers@vrfy.org, jmorris@namei.org, bp@amd64.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PM / Usermodehelper: Introduce reference counting
 to solve usermodehelper_disabled race
References: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com> <20111205212524.27496.58775.stgit@srivatsabhat.in.ibm.com> <20111205213832.GM627@google.com>
In-Reply-To: <20111205213832.GM627@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120702-1396-0000-0000-0000005CCF42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 03:08 AM, Tejun Heo wrote:

> On Tue, Dec 06, 2011 at 02:56:15AM +0530, Srivatsa S. Bhat wrote:
>> This patch adds the necessary synchronization framework to fix the race
>> condition with the 'usermodehelper_disabled' flag, by implementing a
>> refcounting solution. Specifically, it introduces the pair get_usermodehelper()
>> and put_usermodehelper(), which can be used by the readers (those who want to
>> read the value of the usermodehelper_disabled flag, such as _request_firmware()
>> in this case). The writers (those who enable/disable usermodehelpers by
>> setting/resetting that flag) can use the pair umh_control_begin() and
>> umh_control_done().
>>
>> The reason for using a refcounting solution and not just a plain mutex, is
>> that we don't want to unnecessarily serialize all users of request_firmware(),
>> which act as readers. But note that we cannot use reader-writer locks here
>> because the readers sleep (waiting for the firmware load from user-space),
>> and sleeping with spinlocks held is not allowed. So refcounting implemented
>> using mutex locks underneath, seems to be the best fit here.
> 
> I haven't really read the patch yet but, from the description, why not
> use rwsem?
> 

Hey that would be perfect! That hadn't crossed my mind.. Thanks for pointing
it out. I'll respin the patchset using rwsemaphores.

Regards,
Srivatsa S. Bhat

