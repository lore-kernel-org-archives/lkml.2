Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2DBAAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 20:00:35 -0400
Received: from mx2.netapp.com ([216.240.18.37]:59880 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab2DBAAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 20:00:34 -0400
X-IronPort-AV: E=Sophos;i="4.75,353,1330934400"; 
   d="scan'208";a="637870734"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stable@vger.kernel.org>" <stable@vger.kernel.org>,
        "<torvalds@linux-foundation.org>" <torvalds@linux-foundation.org>,
        "<akpm@linux-foundation.org>" <akpm@linux-foundation.org>,
        "<alan@lxorguk.ukuu.org.uk>" <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [ 131/149] NFSv4.1: Fix layoutcommit error handling
Thread-Topic: [ 131/149] NFSv4.1: Fix layoutcommit error handling
Thread-Index: AQHNDrpHMpHrZ0dGYUuOrdMDnvEioJaG81cAgAArpwA=
Date: Sun, 1 Apr 2012 23:59:54 +0000
Message-ID: <056307F7-5680-4520-AA8E-220F525C6506@netapp.com>
References: <20120330194901.854267285@linuxfoundation.org>
 <1333315428.3500.396.camel@deadeye>
In-Reply-To: <1333315428.3500.396.camel@deadeye>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <76E8DD74C5A48E48A2A7A2927B3074E2@tahoe.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1, 2012, at 2:23 PM, Ben Hutchings wrote:

> On Fri, 2012-03-30 at 12:50 -0700, Greg KH wrote:
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>> 
>> commit e59d27e05a6435f8c04d5ad843f37fa795f2eaaa upstream.
>> 
>> Firstly, task->tk_status will always return negative error values,
>> so the current tests for 'NFS4ERR_DELEG_REVOKED' etc. are all being
>> ignored.
>> Secondly, clean up the code so that we only need to test
>> task->tk_status once!
>> 
>> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> 
>> ---
>> fs/nfs/nfs4proc.c |   25 +++++++++++++------------
>> 1 file changed, 13 insertions(+), 12 deletions(-)
>> 
>> --- a/fs/nfs/nfs4proc.c
>> +++ b/fs/nfs/nfs4proc.c
>> @@ -5983,21 +5983,22 @@ nfs4_layoutcommit_done(struct rpc_task *
>> 		return;
>> 
>> 	switch (task->tk_status) { /* Just ignore these failures */
>> -	case NFS4ERR_DELEG_REVOKED: /* layout was recalled */
>> -	case NFS4ERR_BADIOMODE:     /* no IOMODE_RW layout for range */
>> -	case NFS4ERR_BADLAYOUT:     /* no layout */
>> -	case NFS4ERR_GRACE:	    /* loca_recalim always false */
>> +	case -NFS4ERR_DELEG_REVOKED: /* layout was recalled */
>> +	case -NFS4ERR_BADIOMODE:     /* no IOMODE_RW layout for range */
>> +	case -NFS4ERR_BADLAYOUT:     /* no layout */
>> +	case -NFS4ERR_GRACE:	    /* loca_recalim always false */
>> 		task->tk_status = 0;
>> -	}
>> -
>> -	if (nfs4_async_handle_error(task, server, NULL) == -EAGAIN) {
>> -		rpc_restart_call_prepare(task);
>> -		return;
>> -	}
>> -
>> -	if (task->tk_status == 0)
>> +		break;
> 
> It loooks like the previous intent was that for all those specific error
> codes we would end up calling nfs_post_op_update_inode_force_wcc().
> That didn't happen because of the incorrectly signed error codes.  But
> it still won't happen now, because of this break.  Do we really want to
> break here or fall through past 'case 0'?
> 

The 'break' there is deliberate. If the LAYOUTCOMMIT gets an error, then the server will never get to process the post-op GETATTR.

Trond

> Ben.
> 
>> +	case 0:
>> 		nfs_post_op_update_inode_force_wcc(data->args.inode,
>> 						   data->res.fattr);
>> +		break;
>> +	default:
>> +		if (nfs4_async_handle_error(task, server, NULL) == -EAGAIN) {
>> +			rpc_restart_call_prepare(task);
>> +			return;
>> +		}
>> +	}
>> }
>> 
>> static void nfs4_layoutcommit_release(void *calldata)
> 
> -- 
> Ben Hutchings
> I'm always amazed by the number of people who take up solipsism because
> they heard someone else explain it. - E*Borg on alt.fan.pratchett

