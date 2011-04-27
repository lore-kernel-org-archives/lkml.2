Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344Ab1D0X5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:57:49 -0400
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:26893 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760230Ab1D0X5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:57:45 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: xKyYFJAVM1l6yx1H9xh.1vr55g_YnJ4fczfamAQwXyUnMXs
 UKlTd4YVhZN7due8UHhw05LDwl4yxSkcYmtwgVWCfwxBDd4hjBpCzXnrbRZx
 JZuCy7aZkEkIr4LWYm.8dh9zcBE6g4p7B6NCwfpL5fJpUiU1H2zjmr690_EA
 2H0BJDMEGUiLMZVjbbePZ8XlfME7jU.Rc4v6ssqOUFiEdheGO3w_9b.0ifSO
 frReftraUdwE4gcJuQ1aHCwdP0Yv1wzwC7CgywRgUW5vPT5pAInPAlwR.IOx
 .eQdigz8tsqY0n7nRbBvwbZBcqPqsCKxS7qSn_Slo75l5d9qrH4msj83SOKI
 HzGl7cPA1QoDvVFX6fhaD7JXsp.F8VOzZUA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB8AD76.3020405@schaufler-ca.com>
Date: Wed, 27 Apr 2011 16:57:42 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
CC: Roberto Sassu <roberto.sassu@polito.it>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        eparis@redhat.com, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/7] File descriptor labeling
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it> <4DB87A6B.7060805@schaufler-ca.com> <20110427232718.GG30854@boyd.l.tihix.com>
In-Reply-To: <20110427232718.GG30854@boyd.l.tihix.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 4:27 PM, Tyler Hicks wrote:
> On Wed Apr 27, 2011 at 01:19:55PM -0700, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 4/27/2011 5:34 AM, Roberto Sassu wrote:
>>> File descriptor labeling issue
>>>
>>> Actually SELinux and SMACK assign to file descriptors the same label of the
>>> opening process and use it in LSM hooks security_file_permission(),
>>> security_file_fcntl() and others to verify if the 'current' process has the
>>> rights to perform the requested operation.
>>>
>>> Using the credentials of the 'current' process may be not appropriate in
>>> case a file descriptor is opened by a kernel service (i.e. a filesystem)
>>> and made shared among user processes. For instance, in a system with
>>> SELinux and eCryptfs, if the process A opens an encrypted file, eCryptfs
>>> obtains a file descriptor to access the correspondent inode in the lower
>>> filesystem, labeled with the A's label.
>>>
>>> If the process B accesses the same encrypted file, it needs the 'use'
>>> permission on the A's label other than permissions for the lower inode.
>>> However, if B is the first accessing process, A needs the 'use' permission
>>> on the B's label.
>> I am having trouble understanding the argument. I will pose my
>> question in Smack terms, as I can speak most definitively in them.
>>
>> A process running with a Smack label "A" creates a file, and that
>> file gets labeled "A", as it ought. If eCryptfs is behaving correctly
>> this ought not change. If eCryptfs in encrypting the label it needs
>> to do so in such a way as to be able to decrypt it prior to
>> presentation to the vfs layer, where it will be used in an access
>> check. When the process running with a Smack label "B" comes along
>> the vfs code will check the fetched and possibly decrypted "A"
>> against "B" and, unless there is an explicit Smack rule in place
>> granting "B" access to "A", fail.
>>
>> What is the problem? What is eCryptfs doing that prevents this
>> from working?
> Hi Casey - I think what Roberto is getting at is the way eCryptfs uses
> only one lower file per eCryptfs inode. Imagine that there are 5
> files open for ~/secret/foo at the eCryptfs layer, only 1 file is going
> to be open in the lower filesystem and all eCryptfs file operations will
> be multiplexed through it.
>
> To make things more complicated, if the eCryptfs file is opened for
> writing, the lower file must be opened for reading and writing. This is
> because a write operation requires eCryptfs to vfs_read() from the lower
> filesystem, decrypt that data and then vfs_write() the new data.
>
> If the lower file can't be opened O_RDWR by the calling process, the
> request is handed off to a kernel thread to open the lower file on
> behalf of the calling process. It is definitely ugly.

Is eCryptfs handling xattrs? It needs to be if it isn't.

> Roberto, I hope I correctly described the situation that you're trying
> to address. Can you tell me why we can't have a 1:1 mapping of eCryptfs
> files to lower files?
>
> Instead of having just one lower file attached to the eCryptfs inode, we
> could have a list of opened files. There would be one for each eCryptfs
> file that was opened. ecryptfs_writepage() would have to pick, in a
> somewhat random fashion, one of the lower files to use. Of course, we
> would still need to solve the problem of opening the lower file O_RDWR
> when the calling process is only allowed write access (I may have just
> answered my own question of why the 1:1 mapping technique won't solve
> this problem).
>
> Tyler
>
>

