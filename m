Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1ILXXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:23:33 -0400
Received: from nm12.bullet.mail.sp2.yahoo.com ([98.139.91.82]:27130 "HELO
	nm12.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755855Ab1ILXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:23:30 -0400
X-Yahoo-Newman-Id: 858775.15815.bm@omp1015.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zjXWdCQVM1m9SRfEUI5kG7J7S70Hrfs35jvRRg1WQA1kfoX
 C9QeCmG0g6.FnmhO6kQ55ThS1h56Y8R3u9fVf2uN6SZt7z31MhIeWFx6wxFv
 vkPPJ4KqlnzRed8yEHpPE33LS9VZCggtU066nwc09i2ecZLs4na0jfPNhmbc
 sA2ZDCgNG.wZk3DNR9rvNTlblltvx5Byi59dklsguKi6WkyUeEc1zHgns.HR
 Ct5yyyuPCYw6zDtP.9bqp4kf2yWTFi8j7k7sucWMgSpS35YNgScpKnHym9GT
 GxWnwyLtEkA7M1ke1b2Q.sK.LeEdFIjchjjUJBMod.kuix_1jucaU5zs0A_p
 byH5Vo_eWP2uPH6IUAc81U0hvSVbHInCC2d96JMJPwrR4WGjtQq62qPpYBfZ
 3MySfYN.5ktk0Ke1m6A8Wv1onvJ6HYaKN_aN3rTMFVfAdIOFt5m9yfePPdMm
 ptggRQaOjclxEYGxe6TV_GSh0
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E6E946C.5050706@schaufler-ca.com>
Date: Mon, 12 Sep 2011 16:23:24 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Valdis.Kletnieks@vt.edu,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        agruen@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH -V6 00/26] New ACL format for better NFSv4 acl interoperability
References: <1315243548-18664-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4E655049.6060507@schaufler-ca.com> <108028.1315442771@turing-police.cc.vt.edu> <4E6E7ACC.8040003@schaufler-ca.com> <20110912222014.GA17483@fieldses.org> <4E6E89E0.4010406@schaufler-ca.com> <20110912224351.GC17483@fieldses.org>
In-Reply-To: <20110912224351.GC17483@fieldses.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/2011 3:43 PM, J. Bruce Fields wrote:
> On Mon, Sep 12, 2011 at 03:38:24PM -0700, Casey Schaufler wrote:
>> On 9/12/2011 3:20 PM, J. Bruce Fields wrote:
>>> On Mon, Sep 12, 2011 at 02:34:04PM -0700, Casey Schaufler wrote:
>>>> On 9/7/2011 5:46 PM, Valdis.Kletnieks@vt.edu wrote:
>>>>> On Mon, 05 Sep 2011 15:42:17 PDT, Casey Schaufler said:
>>>>>> On 9/5/2011 10:25 AM, Aneesh Kumar K.V wrote:
>>>>>>> The following set of patches implements VFS and ext4 changes needed to implement
>>>>>>> a new acl model for linux. Rich ACLs are an implementation of NFSv4 ACLs,
>>>>>>> extended by file( masks to fit into the standard POSIX file permission model.
>>>>>>> They are designed to work seamlessly locally as well as across the NFSv4 and
>>>>>>> CIFS/SMB2 network file system protocols.
>>>>>> POSIX ACLs predate the LSM and can't be done as an LSM due to
>>>>>> the interactions between mode bits and ACLs as defined by the
>>>>>> POSIX DRAFT specification.
>>> I don't know LSM so don't understand what you mean when you say that
>>> interactions between mode bits and ACLs would make an ACL model hard to
>>> implement as an LSM.
>> POSIX ACLs require that the file permission bits change when
>> the ACL changes. This interaction violates the strict "additional
>> restriction" model of the LSM.
> Oh, OK.  Yes, rich ACLs are the same as POSIX ACLs in this respect.
> When you set an ACL the mode bits are reset to represent an "upper
> bound" on the permissions granted by the ACL.

One of the areas in which the POSIX group was careful almost beyond
reason was the program that uses chmod() judiciously in the absence
of ACLs and how the presence of ACLs might result in a less secure
situation. Thus, a program that does
    stat(..., &buf);
    chmod(..., 0);
    chmod(..., buf.st_mode)

should get the exact same access at the end as it had at the beginning
and the file must be completely inaccessible after the chmod(..., 0)
regardless of the content of the ACL. Without this requirement the ACL
scheme would have worked fine as an LSM. If rich ACLs can't make these
claims, they aren't safe.

>
> --b.
>
>>> But in any case the rich acl/mode bit interactions are similar to the
>>> posix acl/mode bit interactions, so the same issue probably applies.
>> It would help if you knew for sure and could explain the interaction
>> in sufficient detail to justify the position.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

