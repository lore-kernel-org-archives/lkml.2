Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0ITU0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:26:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47729 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab0ITU0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:26:20 -0400
MIME-Version: 1.0
In-Reply-To: <20100920191214.GB7496@one.firstfloor.org>
References: <20100918012939.GA25046@redhat.com>
	<1284779629-15273-1-git-send-email-wad@chromium.org>
	<m1eico1cyv.fsf@fess.ebiederm.org>
	<20100920191214.GB7496@one.firstfloor.org>
Date: Mon, 20 Sep 2010 15:26:18 -0500
Message-ID: <AANLkTi=bKdcHdNSy8dQQeHZd0uxeRekSvf9Ronu5KFV_@mail.gmail.com>
Subject: Re: [PATCH][RFC] v2 exec: move core_pattern pipe helper into the
 crashing namespace
From: Will Drewry <wad@chromium.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 2:12 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> The pipe process needs to run in the namespaces of the process who set
>> the core pattern, not in the namespaces of the dumping process.
>> Otherwise it is possible to trigger a privileged process to run in a
>> context where it's reality that it expected, causing it to misuse
>> it's privileges.  Even if we don't have a privilege problem I think
>> we will have a case of mismatched functionality where the core pattern
>> will not work as expected.
>
> For me it seems rather the other way around: running the helper in some
> highly priviledged namespace is more dangerous. If it runs in the
> same context as the crasher it can do the least amount of damage
> relative to the crash process.
>
> And as Will pointed out it's the only sane way to deal with net namespaces.


I think you're both right.  How it is implemented right now is an
escape from the linux container. If you allow the root user in a
container to mount proc and update core_pattern, they can escape.
(core_pattern = |/well/known/binary_or_scripting_lang)  I'm sure there
are other escapes too (and any umh call is likely an escape like this
one -- e.g., modprobe_path).  That said, using my patch above might
let you traverse a path otherwise blocked by an LSM enforcement (E.g.,
root user runs a process which sets up a vfs namespace with an
encrypted mount and the lsm blocks access to the /proc/[pid]/root -
but core_pattern still runs and with access).

That said, using the setters namespace makes sense to me as a consumer
of core_pattern too. You can set the core_pattern outside of a
chroot/container and collect core dumps there _or_ you can let a
"root" user in a container have their own core collector without
providing a simple escape.  Making format_corename use the correct pid
namespace for translation would make these cases even more seamless.

Unfortunately, I haven't yet looked at doing it that way yet.  The
namespace-transition patch posted is what occurred to me initially.
Perhaps it won't be so hard.  I'll take a look at what it'd take to do
move core_pattern since it'd resolve both the escape/lsm-bypass
scenarios and the mismatch between the arbitrary namespace and the
core_pattern values.

Thanks!
will
