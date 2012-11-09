Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2KIPkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:40:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2KIPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:40:21 -0500
Message-ID: <509D23F5.3080107@canonical.com>
Date: Fri, 09 Nov 2012 09:40:37 -0600
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH cifs-next] fs: cifs: make smb_echo_interval tunable
References: <1352407828-23339-1-git-send-email-chris.j.arges@canonical.com> <20121109060017.63811198@tlielax.poochiereds.net>
In-Reply-To: <20121109060017.63811198@tlielax.poochiereds.net>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 05:00 AM, Jeff Layton wrote:
> On Thu,  8 Nov 2012 14:50:28 -0600
> Chris J Arges <chris.j.arges@canonical.com> wrote:
> 
>> Change SMB_ECHO_INTERVAL to make it a module parameter.
>>
>> BugLink: http://bugs.launchpad.net/bugs/1017622
>> BugLink: https://bugzilla.samba.org/show_bug.cgi?id=9006
>>
> 
> It's customary to write up the reason for a change in the bug
> description. A pointer to a bug tracker is nice as a reference, but
> it's not reasonable to expect someone to chase down a bunch of bug
> tracker links when reading the git logs. It's also possible that
> these bug reports could go away or be unavailable when someone needs
> to track down the reason for a change.
> 
Hi,
Ok I'll fix this in the next version to include a summary of the bug.

>> Reported-by: Oliver Dumschat-Hoette <dumschat-hoette@trisinus.de>
>> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
>> ---
>>  fs/cifs/cifsfs.c   |    5 +++++
>>  fs/cifs/cifsglob.h |    5 +++--
>>  2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 5e62f44..25748b3 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -82,6 +82,11 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
>>  module_param(enable_oplocks, bool, 0644);
>>  MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
>>  
>> +unsigned short smb_echo_timeout = 60;
>> +module_param(smb_echo_timeout, ushort, 0644);
>> +MODULE_PARM_DESC(smb_echo_timeout, "Timeout between two echo requests. "
>> +				   "Default: 60. Timeout in seconds ");
>> +
>>  extern mempool_t *cifs_sm_req_poolp;
>>  extern mempool_t *cifs_req_poolp;
>>  extern mempool_t *cifs_mid_poolp;
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index f5af252..d64dcd3 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -78,8 +78,9 @@
>>  /*           (max path length + 1 for null) * 2 for unicode    */
>>  #define MAX_NAME 514
>>  
>> -/* SMB echo "timeout" -- FIXME: tunable? */
>> -#define SMB_ECHO_INTERVAL (60 * HZ)
>> +/* SMB echo "timeout" */
>> +extern unsigned short smb_echo_timeout;
>> +#define SMB_ECHO_INTERVAL (smb_echo_timeout * HZ)
>>  
>>  #include "cifspdu.h"
>>  
> 
> I'm not so sure I like making this tunable...
> 
Ok, I saw the 'FIXME: tunable?', and thought this was something that
could be exposed as a parameter in the future.

> What would really be better is fixing the code to only echo when there
> are outstanding calls to the server.
> 
> This also seems like a bit of a kludgy workaround for the real problem.
> From looking over the bug reports, it sounds like the real issue is
> that the server is timing out the connection while the client is
> suspended. It then has to wait until the next echo comes around to
> figure that out. Is that the case?
> 
> If so, then I think what you really want here is a way to tell if the
> connection is still valid after resume. Perhaps there's some way to
> force an immediate SMB echo on these connections after resume? With
> that, there'd be little delay at all in contacting the server after a
> resume. The server would presumably send back a RST immediately in such
> a case and we could get on with the business of reconnecting.
> 
> The cifs_demultiplex_thread does make some calls to try_to_freeze().
> Perhaps checking the return value on those and kicking off an immediate
> echo if it returns true would be a better solution?
> 
Great, I'll set up the test environment again and attempt a patch that
does this.

Thanks for the feedback.
--chris j arges


