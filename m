Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047Ab2AVFTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 00:19:21 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:39495 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2AVFTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 00:19:18 -0500
Message-ID: <1327216725.32115.7.camel@lappy>
Subject: Re: BUG: unable to handle kernel paging request at ffffc7ff81000398
 (sys_kexec_load)
From: Sasha Levin <levinsasha928@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, kexec@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jan 2012 02:18:45 -0500
In-Reply-To: <m1lip0s5nt.fsf@fess.ebiederm.org>
References: <1327212367.32115.4.camel@lappy>
	 <m1lip0s5nt.fsf@fess.ebiederm.org>
Content-Type: multipart/mixed; boundary="=-xCUYlWu1nVrQAv+QdvSu"
X-Mailer: Evolution 3.2.2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xCUYlWu1nVrQAv+QdvSu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 2012-01-21 at 20:49 -0800, Eric W. Biederman wrote:
> Sasha Levin <levinsasha928@gmail.com> writes:
> 
> > Hi All,
> >
> > I got the following BUG() while running trinity within KVM tool.
> >
> > It looks like the result of a kexec_load(), but I couldn't find any
> > mention of it in the logs - which is strange since logs are supposed
> > to be flushed before actual syscall runs.
> 
> Interesting.
> 
> The fact that this happens in native_set_pte would suggest that we are
> trying to write to a page table that does not exist.  So this might
> be a layer below kexec_load that has the problem.
> 
> Do you have the kernel you were testing?    A disassembly of the
> native_set_pte, machine_kexec_prepare and sys_kexec_load
> would be interesting, for attempting to trace this back to what went
> wrong.

Yup, It's a pretty simple build of linux-next from today.

>From what I gather, native_set_pte is a simple short function, it also
gets inlined so the disassembly is pretty trivial. I've attached
disassembly of other two functions.

-- 

Sasha.

--=-xCUYlWu1nVrQAv+QdvSu
Content-Disposition: attachment; filename="disasm.txt"
Content-Type: text/plain; name="disasm.txt"; charset="us-ascii"
Content-Transfer-Encoding: 7bit

0000000000000c00 <sys_kexec_load>:
     c00:	55                   	push   %rbp
     c01:	48 89 e5             	mov    %rsp,%rbp
     c04:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
     c0b:	48 89 5d d8          	mov    %rbx,-0x28(%rbp)
     c0f:	4c 89 6d e8          	mov    %r13,-0x18(%rbp)
     c13:	4c 89 75 f0          	mov    %r14,-0x10(%rbp)
     c17:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
     c1b:	4c 89 65 e0          	mov    %r12,-0x20(%rbp)
     c1f:	49 89 d7             	mov    %rdx,%r15
     c22:	49 89 fe             	mov    %rdi,%r14
     c25:	48 89 f3             	mov    %rsi,%rbx
     c28:	49 89 cd             	mov    %rcx,%r13
     c2b:	bf 16 00 00 00       	mov    $0x16,%edi
     c30:	e8 00 00 00 00       	callq  c35 <sys_kexec_load+0x35>
     c35:	89 c2                	mov    %eax,%edx
     c37:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
     c3e:	84 d2                	test   %dl,%dl
     c40:	75 1e                	jne    c60 <sys_kexec_load+0x60>
     c42:	48 8b 5d d8          	mov    -0x28(%rbp),%rbx
     c46:	4c 8b 65 e0          	mov    -0x20(%rbp),%r12
     c4a:	4c 8b 6d e8          	mov    -0x18(%rbp),%r13
     c4e:	4c 8b 75 f0          	mov    -0x10(%rbp),%r14
     c52:	4c 8b 7d f8          	mov    -0x8(%rbp),%r15
     c56:	c9                   	leaveq 
     c57:	c3                   	retq   
     c58:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     c5f:	00 
     c60:	b0 ea                	mov    $0xea,%al
     c62:	41 f7 c5 fc ff 00 00 	test   $0xfffc,%r13d
     c69:	75 d7                	jne    c42 <sys_kexec_load+0x42>
     c6b:	4c 89 ea             	mov    %r13,%rdx
     c6e:	81 e2 00 00 ff ff    	and    $0xffff0000,%edx
     c74:	74 09                	je     c7f <sys_kexec_load+0x7f>
     c76:	48 81 fa 00 00 3e 00 	cmp    $0x3e0000,%rdx
     c7d:	75 c3                	jne    c42 <sys_kexec_load+0x42>
     c7f:	48 c7 c0 ea ff ff ff 	mov    $0xffffffffffffffea,%rax
     c86:	48 83 fb 10          	cmp    $0x10,%rbx
     c8a:	77 b6                	ja     c42 <sys_kexec_load+0x42>
     c8c:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     c93:	e8 00 00 00 00       	callq  c98 <sys_kexec_load+0x98>
     c98:	89 c2                	mov    %eax,%edx
     c9a:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
     ca1:	85 d2                	test   %edx,%edx
     ca3:	74 9d                	je     c42 <sys_kexec_load+0x42>
     ca5:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
     cac:	00 
     cad:	44 89 e8             	mov    %r13d,%eax
     cb0:	83 e0 01             	and    $0x1,%eax
     cb3:	89 45 94             	mov    %eax,-0x6c(%rbp)
     cb6:	48 c7 c0 00 00 00 00 	mov    $0x0,%rax
     cbd:	48 0f 44 45 a0       	cmove  -0x60(%rbp),%rax
     cc2:	45 31 e4             	xor    %r12d,%r12d
     cc5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
     cc9:	48 85 db             	test   %rbx,%rbx
     ccc:	0f 84 04 03 00 00    	je     fd6 <sys_kexec_load+0x3d6>
     cd2:	41 f6 c5 01          	test   $0x1,%r13b
     cd6:	0f 84 fd 03 00 00    	je     10d9 <sys_kexec_load+0x4d9>
     cdc:	31 c0                	xor    %eax,%eax
     cde:	83 7d 94 00          	cmpl   $0x0,-0x6c(%rbp)
     ce2:	0f 85 75 01 00 00    	jne    e5d <sys_kexec_load+0x25d>
     ce8:	49 89 c4             	mov    %rax,%r12
     ceb:	41 80 e5 02          	and    $0x2,%r13b
     cef:	74 09                	je     cfa <sys_kexec_load+0xfa>
     cf1:	41 80 8c 24 78 02 00 	orb    $0x2,0x278(%r12)
     cf8:	00 02 
     cfa:	4c 89 e7             	mov    %r12,%rdi
     cfd:	e8 00 00 00 00       	callq  d02 <sys_kexec_load+0x102>
     d02:	85 c0                	test   %eax,%eax
     d04:	0f 85 95 01 00 00    	jne    e9f <sys_kexec_load+0x29f>
     d0a:	4d 89 e5             	mov    %r12,%r13
     d0d:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
     d14:	00 
     d15:	48 89 5d 80          	mov    %rbx,-0x80(%rbp)
     d19:	41 f6 84 24 78 02 00 	testb  $0x1,0x278(%r12)
     d20:	00 01 
     d22:	0f 85 bc 02 00 00    	jne    fe4 <sys_kexec_load+0x3e4>
     d28:	49 8b 45 40          	mov    0x40(%r13),%rax
     d2c:	4c 89 e7             	mov    %r12,%rdi
     d2f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
     d33:	49 8b 45 48          	mov    0x48(%r13),%rax
     d37:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
     d3b:	4d 8b 75 50          	mov    0x50(%r13),%r14
     d3f:	4d 8b 7d 58          	mov    0x58(%r13),%r15
     d43:	4c 89 f3             	mov    %r14,%rbx
     d46:	48 81 e3 00 f0 ff ff 	and    $0xfffffffffffff000,%rbx
     d4d:	48 89 de             	mov    %rbx,%rsi
     d50:	48 83 ce 01          	or     $0x1,%rsi
     d54:	e8 c7 f8 ff ff       	callq  620 <kimage_add_entry>
     d59:	83 f8 00             	cmp    $0x0,%eax
     d5c:	0f 85 15 04 00 00    	jne    1177 <sys_kexec_load+0x577>
     d62:	49 89 5c 24 18       	mov    %rbx,0x18(%r12)
     d67:	4c 89 6d a8          	mov    %r13,-0x58(%rbp)
     d6b:	4d 85 ff             	test   %r15,%r15
     d6e:	0f 84 1a 02 00 00    	je     f8e <sys_kexec_load+0x38e>
     d74:	4c 89 f2             	mov    %r14,%rdx
     d77:	be d2 00 02 00       	mov    $0x200d2,%esi
     d7c:	4c 89 e7             	mov    %r12,%rdi
     d7f:	e8 dc f5 ff ff       	callq  360 <kimage_alloc_page>
     d84:	48 85 c0             	test   %rax,%rax
     d87:	0f 84 39 03 00 00    	je     10c6 <sys_kexec_load+0x4c6>
     d8d:	48 bb 00 00 00 00 00 	movabs $0x160000000000,%rbx
     d94:	16 00 00 
     d97:	4c 89 e7             	mov    %r12,%rdi
     d9a:	48 8d 1c 18          	lea    (%rax,%rbx,1),%rbx
     d9e:	48 c1 fb 06          	sar    $0x6,%rbx
     da2:	48 c1 e3 0c          	shl    $0xc,%rbx
     da6:	48 89 de             	mov    %rbx,%rsi
     da9:	48 83 ce 08          	or     $0x8,%rsi
     dad:	e8 6e f8 ff ff       	callq  620 <kimage_add_entry>
     db2:	83 f8 00             	cmp    $0x0,%eax
     db5:	0f 85 cd 01 00 00    	jne    f88 <sys_kexec_load+0x388>
     dbb:	49 81 44 24 18 00 10 	addq   $0x1000,0x18(%r12)
     dc2:	00 00 
     dc4:	31 d2                	xor    %edx,%edx
     dc6:	be 32 00 00 00       	mov    $0x32,%esi
     dcb:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     dd2:	e8 00 00 00 00       	callq  dd7 <sys_kexec_load+0x1d7>
     dd7:	48 b8 00 00 00 00 00 	movabs $0xffff880000000000,%rax
     dde:	88 ff ff 
     de1:	48 8d 04 03          	lea    (%rbx,%rax,1),%rax
     de5:	bb 00 10 00 00       	mov    $0x1000,%ebx
     dea:	48 89 c7             	mov    %rax,%rdi
     ded:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
     df4:	e8 00 00 00 00       	callq  df9 <sys_kexec_load+0x1f9>
     df9:	4c 8b 6d b0          	mov    -0x50(%rbp),%r13
     dfd:	4c 89 f7             	mov    %r14,%rdi
     e00:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
     e06:	48 29 fb             	sub    %rdi,%rbx
     e09:	48 89 bd 70 ff ff ff 	mov    %rdi,-0x90(%rbp)
     e10:	4c 39 fb             	cmp    %r15,%rbx
     e13:	49 0f 47 df          	cmova  %r15,%rbx
     e17:	48 3b 5d b0          	cmp    -0x50(%rbp),%rbx
     e1b:	4c 0f 46 eb          	cmovbe %rbx,%r13
     e1f:	e8 00 00 00 00       	callq  e24 <sys_kexec_load+0x224>
     e24:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
     e2b:	48 8b bd 70 ff ff ff 	mov    -0x90(%rbp),%rdi
     e32:	44 89 ea             	mov    %r13d,%edx
     e35:	48 8d 3c 38          	lea    (%rax,%rdi,1),%rdi
     e39:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
     e3d:	e8 00 00 00 00       	callq  e42 <sys_kexec_load+0x242>
     e42:	85 c0                	test   %eax,%eax
     e44:	0f 85 12 01 00 00    	jne    f5c <sys_kexec_load+0x35c>
     e4a:	4c 29 6d b0          	sub    %r13,-0x50(%rbp)
     e4e:	49 01 de             	add    %rbx,%r14
     e51:	48 01 5d b8          	add    %rbx,-0x48(%rbp)
     e55:	49 29 df             	sub    %rbx,%r15
     e58:	e9 0e ff ff ff       	jmpq   d6b <sys_kexec_load+0x16b>
     e5d:	4c 89 e7             	mov    %r12,%rdi
     e60:	48 87 3d 00 00 00 00 	xchg   %rdi,0x0(%rip)        # e67 <sys_kexec_load+0x267>
     e67:	e8 f4 f3 ff ff       	callq  260 <kimage_free>
     e6c:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
     e73:	00 
     e74:	b8 9d ff ff ff       	mov    $0xffffff9d,%eax
     e79:	4c 3b 35 00 00 00 00 	cmp    0x0(%rip),%r14        # e80 <sys_kexec_load+0x280>
     e80:	73 44                	jae    ec6 <sys_kexec_load+0x2c6>
     e82:	89 85 78 ff ff ff    	mov    %eax,-0x88(%rbp)
     e88:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
     e8c:	45 31 e4             	xor    %r12d,%r12d
     e8f:	e8 00 00 00 00       	callq  e94 <sys_kexec_load+0x294>
     e94:	e8 00 00 00 00       	callq  e99 <sys_kexec_load+0x299>
     e99:	8b 85 78 ff ff ff    	mov    -0x88(%rbp),%eax
     e9f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%rbp)
     ea5:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     eac:	e8 00 00 00 00       	callq  eb1 <sys_kexec_load+0x2b1>
     eb1:	4c 89 e7             	mov    %r12,%rdi
     eb4:	e8 a7 f3 ff ff       	callq  260 <kimage_free>
     eb9:	8b 85 78 ff ff ff    	mov    -0x88(%rbp),%eax
     ebf:	48 98                	cltq   
     ec1:	e9 7c fd ff ff       	jmpq   c42 <sys_kexec_load+0x42>
     ec6:	4c 3b 35 00 00 00 00 	cmp    0x0(%rip),%r14        # ecd <sys_kexec_load+0x2cd>
     ecd:	77 b3                	ja     e82 <sys_kexec_load+0x282>
     ecf:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
     ed3:	4c 89 f9             	mov    %r15,%rcx
     ed6:	48 89 da             	mov    %rbx,%rdx
     ed9:	4c 89 f6             	mov    %r14,%rsi
     edc:	e8 1f f8 ff ff       	callq  700 <do_kimage_alloc>
     ee1:	85 c0                	test   %eax,%eax
     ee3:	75 9d                	jne    e82 <sys_kexec_load+0x282>
     ee5:	4c 8b 65 c8          	mov    -0x38(%rbp),%r12
     ee9:	48 8b 0d 00 00 00 00 	mov    0x0(%rip),%rcx        # ef0 <sys_kexec_load+0x2f0>
     ef0:	4c 89 e0             	mov    %r12,%rax
     ef3:	41 80 8c 24 78 02 00 	orb    $0x1,0x278(%r12)
     efa:	00 01 
     efc:	49 89 8c 24 70 02 00 	mov    %rcx,0x270(%r12)
     f03:	00 
     f04:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # f0b <sys_kexec_load+0x30b>
     f0b:	31 d2                	xor    %edx,%edx
     f0d:	48 8b 70 50          	mov    0x50(%rax),%rsi
     f11:	4c 8b 40 58          	mov    0x58(%rax),%r8
     f15:	48 39 f1             	cmp    %rsi,%rcx
     f18:	77 4c                	ja     f66 <sys_kexec_load+0x366>
     f1a:	4a 8d 74 06 ff       	lea    -0x1(%rsi,%r8,1),%rsi
     f1f:	48 39 fe             	cmp    %rdi,%rsi
     f22:	77 42                	ja     f66 <sys_kexec_load+0x366>
     f24:	48 ff c2             	inc    %rdx
     f27:	48 83 c0 20          	add    $0x20,%rax
     f2b:	48 39 d3             	cmp    %rdx,%rbx
     f2e:	77 dd                	ja     f0d <sys_kexec_load+0x30d>
     f30:	4c 89 e7             	mov    %r12,%rdi
     f33:	be 01 00 00 00       	mov    $0x1,%esi
     f38:	e8 00 00 00 00       	callq  f3d <sys_kexec_load+0x33d>
     f3d:	49 89 44 24 28       	mov    %rax,0x28(%r12)
     f42:	4c 8b 65 c8          	mov    -0x38(%rbp),%r12
     f46:	49 83 7c 24 28 00    	cmpq   $0x0,0x28(%r12)
     f4c:	74 22                	je     f70 <sys_kexec_load+0x370>
     f4e:	e8 00 00 00 00       	callq  f53 <sys_kexec_load+0x353>
     f53:	e9 93 fd ff ff       	jmpq   ceb <sys_kexec_load+0xeb>
     f58:	4c 8b 65 a8          	mov    -0x58(%rbp),%r12
     f5c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
     f61:	e9 39 ff ff ff       	jmpq   e9f <sys_kexec_load+0x29f>
     f66:	b8 9d ff ff ff       	mov    $0xffffff9d,%eax
     f6b:	e9 12 ff ff ff       	jmpq   e82 <sys_kexec_load+0x282>
     f70:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
     f77:	31 c0                	xor    %eax,%eax
     f79:	e8 00 00 00 00       	callq  f7e <sys_kexec_load+0x37e>
     f7e:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
     f83:	e9 fa fe ff ff       	jmpq   e82 <sys_kexec_load+0x282>
     f88:	0f 8d 36 fe ff ff    	jge    dc4 <sys_kexec_load+0x1c4>
     f8e:	4c 8b 6d a8          	mov    -0x58(%rbp),%r13
     f92:	85 c0                	test   %eax,%eax
     f94:	0f 85 05 ff ff ff    	jne    e9f <sys_kexec_load+0x29f>
     f9a:	48 ff 45 98          	incq   -0x68(%rbp)
     f9e:	49 83 c5 20          	add    $0x20,%r13
     fa2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
     fa6:	48 39 45 80          	cmp    %rax,-0x80(%rbp)
     faa:	0f 87 69 fd ff ff    	ja     d19 <sys_kexec_load+0x119>
     fb0:	49 8b 44 24 08       	mov    0x8(%r12),%rax
     fb5:	48 83 38 00          	cmpq   $0x0,(%rax)
     fb9:	74 09                	je     fc4 <sys_kexec_load+0x3c4>
     fbb:	48 83 c0 08          	add    $0x8,%rax
     fbf:	49 89 44 24 08       	mov    %rax,0x8(%r12)
     fc4:	48 c7 00 04 00 00 00 	movq   $0x4,(%rax)
     fcb:	83 7d 94 00          	cmpl   $0x0,-0x6c(%rbp)
     fcf:	74 05                	je     fd6 <sys_kexec_load+0x3d6>
     fd1:	e8 00 00 00 00       	callq  fd6 <sys_kexec_load+0x3d6>
     fd6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
     fda:	4c 87 20             	xchg   %r12,(%rax)
     fdd:	31 c0                	xor    %eax,%eax
     fdf:	e9 bb fe ff ff       	jmpq   e9f <sys_kexec_load+0x29f>
     fe4:	49 8b 45 40          	mov    0x40(%r13),%rax
     fe8:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
     fec:	4d 8b 75 48          	mov    0x48(%r13),%r14
     ff0:	49 8b 5d 58          	mov    0x58(%r13),%rbx
     ff4:	49 8b 45 50          	mov    0x50(%r13),%rax
     ff8:	4c 89 65 a8          	mov    %r12,-0x58(%rbp)
     ffc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    1000:	48 85 db             	test   %rbx,%rbx
    1003:	0f 84 c7 00 00 00    	je     10d0 <sys_kexec_load+0x4d0>
    1009:	4c 8b 65 b8          	mov    -0x48(%rbp),%r12
    100d:	48 b8 00 00 00 00 00 	movabs $0xffffea0000000000,%rax
    1014:	ea ff ff 
    1017:	49 c1 ec 0c          	shr    $0xc,%r12
    101b:	49 c1 e4 06          	shl    $0x6,%r12
    101f:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
    1023:	48 85 c0             	test   %rax,%rax
    1026:	0f 84 96 00 00 00    	je     10c2 <sys_kexec_load+0x4c2>
    102c:	31 d2                	xor    %edx,%edx
    102e:	be 32 00 00 00       	mov    $0x32,%esi
    1033:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    103a:	41 bf 00 10 00 00    	mov    $0x1000,%r15d
    1040:	e8 00 00 00 00       	callq  1045 <sys_kexec_load+0x445>
    1045:	4c 89 e2             	mov    %r12,%rdx
    1048:	48 b8 00 00 00 00 00 	movabs $0xffff880000000000,%rax
    104f:	88 ff ff 
    1052:	48 c1 e2 06          	shl    $0x6,%rdx
    1056:	48 01 c2             	add    %rax,%rdx
    1059:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
    105d:	25 ff 0f 00 00       	and    $0xfff,%eax
    1062:	48 01 c2             	add    %rax,%rdx
    1065:	49 29 c7             	sub    %rax,%r15
    1068:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
    106c:	49 39 df             	cmp    %rbx,%r15
    106f:	4c 0f 47 fb          	cmova  %rbx,%r15
    1073:	4d 89 fc             	mov    %r15,%r12
    1076:	4d 39 f7             	cmp    %r14,%r15
    1079:	76 17                	jbe    1092 <sys_kexec_load+0x492>
    107b:	48 8b 7d 88          	mov    -0x78(%rbp),%rdi
    107f:	4c 89 fa             	mov    %r15,%rdx
    1082:	4c 01 f7             	add    %r14,%rdi
    1085:	4c 29 f2             	sub    %r14,%rdx
    1088:	31 f6                	xor    %esi,%esi
    108a:	4d 89 f4             	mov    %r14,%r12
    108d:	e8 00 00 00 00       	callq  1092 <sys_kexec_load+0x492>
    1092:	e8 00 00 00 00       	callq  1097 <sys_kexec_load+0x497>
    1097:	44 89 e2             	mov    %r12d,%edx
    109a:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
    109e:	48 8b 7d 88          	mov    -0x78(%rbp),%rdi
    10a2:	e8 00 00 00 00       	callq  10a7 <sys_kexec_load+0x4a7>
    10a7:	85 c0                	test   %eax,%eax
    10a9:	0f 85 a9 fe ff ff    	jne    f58 <sys_kexec_load+0x358>
    10af:	4d 29 e6             	sub    %r12,%r14
    10b2:	4c 01 7d b8          	add    %r15,-0x48(%rbp)
    10b6:	4c 01 7d b0          	add    %r15,-0x50(%rbp)
    10ba:	4c 29 fb             	sub    %r15,%rbx
    10bd:	e9 3e ff ff ff       	jmpq   1000 <sys_kexec_load+0x400>
    10c2:	4c 8b 65 a8          	mov    -0x58(%rbp),%r12
    10c6:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    10cb:	e9 cf fd ff ff       	jmpq   e9f <sys_kexec_load+0x29f>
    10d0:	4c 8b 65 a8          	mov    -0x58(%rbp),%r12
    10d4:	e9 c1 fe ff ff       	jmpq   f9a <sys_kexec_load+0x39a>
    10d9:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
    10e0:	00 
    10e1:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
    10e5:	4c 89 f9             	mov    %r15,%rcx
    10e8:	48 89 da             	mov    %rbx,%rdx
    10eb:	4c 89 f6             	mov    %r14,%rsi
    10ee:	e8 0d f6 ff ff       	callq  700 <do_kimage_alloc>
    10f3:	85 c0                	test   %eax,%eax
    10f5:	75 51                	jne    1148 <sys_kexec_load+0x548>
    10f7:	4c 8b 65 c8          	mov    -0x38(%rbp),%r12
    10fb:	be 01 00 00 00       	mov    $0x1,%esi
    1100:	4c 89 e7             	mov    %r12,%rdi
    1103:	e8 00 00 00 00       	callq  1108 <sys_kexec_load+0x508>
    1108:	49 89 44 24 28       	mov    %rax,0x28(%r12)
    110d:	4c 8b 75 c8          	mov    -0x38(%rbp),%r14
    1111:	49 83 7e 28 00       	cmpq   $0x0,0x28(%r14)
    1116:	74 4a                	je     1162 <sys_kexec_load+0x562>
    1118:	31 f6                	xor    %esi,%esi
    111a:	4c 89 f7             	mov    %r14,%rdi
    111d:	e8 00 00 00 00       	callq  1122 <sys_kexec_load+0x522>
    1122:	49 89 46 30          	mov    %rax,0x30(%r14)
    1126:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
    112a:	48 83 78 30 00       	cmpq   $0x0,0x30(%rax)
    112f:	0f 85 b3 fb ff ff    	jne    ce8 <sys_kexec_load+0xe8>
    1135:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    113c:	31 c0                	xor    %eax,%eax
    113e:	e8 00 00 00 00       	callq  1143 <sys_kexec_load+0x543>
    1143:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    1148:	89 85 78 ff ff ff    	mov    %eax,-0x88(%rbp)
    114e:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
    1152:	e8 00 00 00 00       	callq  1157 <sys_kexec_load+0x557>
    1157:	8b 85 78 ff ff ff    	mov    -0x88(%rbp),%eax
    115d:	e9 3d fd ff ff       	jmpq   e9f <sys_kexec_load+0x29f>
    1162:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
    1169:	31 c0                	xor    %eax,%eax
    116b:	e8 00 00 00 00       	callq  1170 <sys_kexec_load+0x570>
    1170:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
    1175:	eb d1                	jmp    1148 <sys_kexec_load+0x548>
    1177:	0f 8d ea fb ff ff    	jge    d67 <sys_kexec_load+0x167>
    117d:	0f 1f 00             	nopl   (%rax)
    1180:	e9 0d fe ff ff       	jmpq   f92 <sys_kexec_load+0x392>
    1185:	66 66 2e 0f 1f 84 00 	data32 nopw %cs:0x0(%rax,%rax,1)
    118c:	00 00 00 00 

0000000000000040 <machine_kexec_prepare>:
  40:	55                   	push   %rbp
  41:	48 b9 00 00 00 00 00 	movabs $0x160000000000,%rcx
  48:	16 00 00 
  4b:	48 89 e5             	mov    %rsp,%rbp
  4e:	48 89 c8             	mov    %rcx,%rax
  51:	41 57                	push   %r15
  53:	48 ba 00 00 00 00 00 	movabs $0xffff880000000000,%rdx
  5a:	88 ff ff 
  5d:	41 56                	push   %r14
  5f:	41 55                	push   %r13
  61:	41 54                	push   %r12
  63:	53                   	push   %rbx
  64:	48 83 ec 58          	sub    $0x58,%rsp
  68:	48 89 7d c0          	mov    %rdi,-0x40(%rbp)
  6c:	48 03 47 28          	add    0x28(%rdi),%rax
  70:	48 c1 f8 06          	sar    $0x6,%rax
  74:	48 c1 e0 0c          	shl    $0xc,%rax
  78:	48 01 d0             	add    %rdx,%rax
  7b:	48 89 45 98          	mov    %rax,-0x68(%rbp)
  7f:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 86 <machine_kexec_prepare+0x46>
  86:	48 c1 e0 0c          	shl    $0xc,%rax
  8a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8e:	48 85 c0             	test   %rax,%rax
  91:	0f 84 b1 07 00 00    	je     848 <machine_kexec_prepare+0x808>
  97:	48 8b 7d 98          	mov    -0x68(%rbp),%rdi
  9b:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
  a2:	00 
  a3:	48 89 7d a0          	mov    %rdi,-0x60(%rbp)
  a7:	31 f6                	xor    %esi,%esi
  a9:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  ad:	e8 00 00 00 00       	callq  b2 <machine_kexec_prepare+0x72>
  b2:	48 85 c0             	test   %rax,%rax
  b5:	0f 84 c1 05 00 00    	je     67c <machine_kexec_prepare+0x63c>
  bb:	48 ba 00 00 00 00 00 	movabs $0x160000000000,%rdx
  c2:	16 00 00 
  c5:	48 bf 00 00 00 00 00 	movabs $0xffff880000000000,%rdi
  cc:	88 ff ff 
  cf:	48 01 d0             	add    %rdx,%rax
  d2:	4c 8b 75 a8          	mov    -0x58(%rbp),%r14
  d6:	48 c1 f8 06          	sar    $0x6,%rax
  da:	49 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%r14
  e1:	48 c1 e0 0c          	shl    $0xc,%rax
  e5:	48 01 c7             	add    %rax,%rdi
  e8:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  ef:	00 00 00 
  f2:	48 89 7d 90          	mov    %rdi,-0x70(%rbp)
  f6:	4c 01 f0             	add    %r14,%rax
  f9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  fd:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
 101:	49 39 c6             	cmp    %rax,%r14
 104:	0f 83 22 01 00 00    	jae    22c <machine_kexec_prepare+0x1ec>
 10a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
 110:	4c 39 75 b8          	cmp    %r14,-0x48(%rbp)
 114:	0f 86 12 01 00 00    	jbe    22c <machine_kexec_prepare+0x1ec>
 11a:	31 f6                	xor    %esi,%esi
 11c:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
 120:	e8 00 00 00 00       	callq  125 <machine_kexec_prepare+0xe5>
 125:	48 85 c0             	test   %rax,%rax
 128:	0f 84 4e 05 00 00    	je     67c <machine_kexec_prepare+0x63c>
 12e:	49 bf 00 00 00 00 00 	movabs $0x160000000000,%r15
 135:	16 00 00 
 138:	48 ba 00 00 00 00 00 	movabs $0xffff880000000000,%rdx
 13f:	88 ff ff 
 142:	4e 8d 3c 38          	lea    (%rax,%r15,1),%r15
 146:	4c 89 f3             	mov    %r14,%rbx
 149:	49 c1 ff 06          	sar    $0x6,%r15
 14d:	48 81 e3 00 f0 ff ff 	and    $0xfffffffffffff000,%rbx
 154:	49 c1 e7 0c          	shl    $0xc,%r15
 158:	4c 8d ab 00 00 00 40 	lea    0x40000000(%rbx),%r13
 15f:	49 01 d7             	add    %rdx,%r15
 162:	4c 39 eb             	cmp    %r13,%rbx
 165:	73 6b                	jae    1d2 <machine_kexec_prepare+0x192>
 167:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 16f <machine_kexec_prepare+0x12f>
 16e:	00 
 16f:	0f 84 1b 05 00 00    	je     690 <machine_kexec_prepare+0x650>
 175:	48 89 df             	mov    %rbx,%rdi
 178:	4d 89 fc             	mov    %r15,%r12
 17b:	48 81 cf e3 01 00 00 	or     $0x1e3,%rdi
 182:	eb 20                	jmp    1a4 <machine_kexec_prepare+0x164>
 184:	0f 1f 40 00          	nopl   0x0(%rax)
 188:	49 83 c4 08          	add    $0x8,%r12
 18c:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 194 <machine_kexec_prepare+0x154>
 193:	00 
 194:	0f 84 f6 04 00 00    	je     690 <machine_kexec_prepare+0x650>
 19a:	48 89 df             	mov    %rbx,%rdi
 19d:	48 81 cf e3 01 00 00 	or     $0x1e3,%rdi
 1a4:	ff 14 25 00 00 00 00 	callq  *0x0
 1ab:	48 89 c6             	mov    %rax,%rsi
 1ae:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 1b6 <machine_kexec_prepare+0x176>
 1b5:	00 
 1b6:	0f 84 d6 04 00 00    	je     692 <machine_kexec_prepare+0x652>
 1bc:	4c 89 e7             	mov    %r12,%rdi
 1bf:	ff 14 25 00 00 00 00 	callq  *0x0
 1c6:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
 1cd:	49 39 dd             	cmp    %rbx,%r13
 1d0:	77 b6                	ja     188 <machine_kexec_prepare+0x148>
 1d2:	4c 89 ff             	mov    %r15,%rdi
 1d5:	e8 00 00 00 00       	callq  1da <machine_kexec_prepare+0x19a>
 1da:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 1e2 <machine_kexec_prepare+0x1a2>
 1e1:	00 
 1e2:	0f 84 5e 06 00 00    	je     846 <machine_kexec_prepare+0x806>
 1e8:	48 89 c7             	mov    %rax,%rdi
 1eb:	48 83 cf 63          	or     $0x63,%rdi
 1ef:	ff 14 25 00 00 00 00 	callq  *0x0
 1f6:	48 89 c6             	mov    %rax,%rsi
 1f9:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 201 <machine_kexec_prepare+0x1c1>
 200:	00 
 201:	0f 84 28 06 00 00    	je     82f <machine_kexec_prepare+0x7ef>
 207:	48 83 45 c8 08       	addq   $0x8,-0x38(%rbp)
 20c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
 210:	48 83 ef 08          	sub    $0x8,%rdi
 214:	ff 14 25 00 00 00 00 	callq  *0x0
 21b:	49 81 c6 00 00 00 40 	add    $0x40000000,%r14
 222:	4c 39 75 b0          	cmp    %r14,-0x50(%rbp)
 226:	0f 87 e4 fe ff ff    	ja     110 <machine_kexec_prepare+0xd0>
 22c:	4c 39 75 b0          	cmp    %r14,-0x50(%rbp)
 230:	76 65                	jbe    297 <machine_kexec_prepare+0x257>
 232:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 23a <machine_kexec_prepare+0x1fa>
 239:	00 
 23a:	0f 84 06 06 00 00    	je     846 <machine_kexec_prepare+0x806>
 240:	48 8b 5d c8          	mov    -0x38(%rbp),%rbx
 244:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
 248:	48 83 c3 08          	add    $0x8,%rbx
 24c:	4c 8b 65 b0          	mov    -0x50(%rbp),%r12
 250:	eb 15                	jmp    267 <machine_kexec_prepare+0x227>
 252:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 25a <machine_kexec_prepare+0x21a>
 259:	00 
 25a:	0f 84 e6 05 00 00    	je     846 <machine_kexec_prepare+0x806>
 260:	48 89 da             	mov    %rbx,%rdx
 263:	48 83 c3 08          	add    $0x8,%rbx
 267:	31 ff                	xor    %edi,%edi
 269:	ff 14 25 00 00 00 00 	callq  *0x0
 270:	48 89 c6             	mov    %rax,%rsi
 273:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 27b <machine_kexec_prepare+0x23b>
 27a:	00 
 27b:	0f 84 ae 05 00 00    	je     82f <machine_kexec_prepare+0x7ef>
 281:	48 89 d7             	mov    %rdx,%rdi
 284:	ff 14 25 00 00 00 00 	callq  *0x0
 28b:	49 81 c6 00 00 00 40 	add    $0x40000000,%r14
 292:	4d 39 f4             	cmp    %r14,%r12
 295:	77 bb                	ja     252 <machine_kexec_prepare+0x212>
 297:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
 29b:	e8 00 00 00 00       	callq  2a0 <machine_kexec_prepare+0x260>
 2a0:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 2a8 <machine_kexec_prepare+0x268>
 2a7:	00 
 2a8:	0f 84 96 05 00 00    	je     844 <machine_kexec_prepare+0x804>
 2ae:	48 89 c6             	mov    %rax,%rsi
 2b1:	48 83 ce 63          	or     $0x63,%rsi
 2b5:	48 89 f7             	mov    %rsi,%rdi
 2b8:	ff 14 25 00 00 00 00 	callq  *0x0
 2bf:	48 89 c6             	mov    %rax,%rsi
 2c2:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 2ca <machine_kexec_prepare+0x28a>
 2c9:	00 
 2ca:	0f 84 8d 05 00 00    	je     85d <machine_kexec_prepare+0x81d>
 2d0:	48 83 45 a0 08       	addq   $0x8,-0x60(%rbp)
 2d5:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
 2d9:	48 83 ef 08          	sub    $0x8,%rdi
 2dd:	ff 14 25 00 00 00 00 	callq  *0x0
 2e4:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
 2eb:	00 00 00 
 2ee:	48 ba ff ff ff ff ff 	movabs $0xffffffffffff,%rdx
 2f5:	ff 00 00 
 2f8:	48 01 45 a8          	add    %rax,-0x58(%rbp)
 2fc:	48 39 55 a8          	cmp    %rdx,-0x58(%rbp)
 300:	77 0e                	ja     310 <machine_kexec_prepare+0x2d0>
 302:	48 8b 7d a8          	mov    -0x58(%rbp),%rdi
 306:	48 39 7d b8          	cmp    %rdi,-0x48(%rbp)
 30a:	0f 87 97 fd ff ff    	ja     a7 <machine_kexec_prepare+0x67>
 310:	48 8b 5d a0          	mov    -0x60(%rbp),%rbx
 314:	49 bd ff ff ff ff ff 	movabs $0xffffffffffff,%r13
 31b:	ff 00 00 
 31e:	45 31 e4             	xor    %r12d,%r12d
 321:	49 be 00 00 00 00 80 	movabs $0x8000000000,%r14
 328:	00 00 00 
 32b:	4c 8b 7d a8          	mov    -0x58(%rbp),%r15
 32f:	eb 3a                	jmp    36b <machine_kexec_prepare+0x32b>
 331:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 339 <machine_kexec_prepare+0x2f9>
 338:	00 
 339:	0f 84 05 05 00 00    	je     844 <machine_kexec_prepare+0x804>
 33f:	4c 89 e7             	mov    %r12,%rdi
 342:	ff 14 25 00 00 00 00 	callq  *0x0
 349:	48 89 c6             	mov    %rax,%rsi
 34c:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 354 <machine_kexec_prepare+0x314>
 353:	00 
 354:	0f 84 03 05 00 00    	je     85d <machine_kexec_prepare+0x81d>
 35a:	48 89 df             	mov    %rbx,%rdi
 35d:	ff 14 25 00 00 00 00 	callq  *0x0
 364:	4d 01 f7             	add    %r14,%r15
 367:	48 83 c3 08          	add    $0x8,%rbx
 36b:	4d 39 ef             	cmp    %r13,%r15
 36e:	76 c1                	jbe    331 <machine_kexec_prepare+0x2f1>
 370:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
 374:	48 8b 58 20          	mov    0x20(%rax),%rbx
 378:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
 37f:	49 89 dc             	mov    %rbx,%r12
 382:	49 c1 ec 24          	shr    $0x24,%r12
 386:	41 81 e4 f8 0f 00 00 	and    $0xff8,%r12d
 38d:	4c 03 65 98          	add    -0x68(%rbp),%r12
 391:	41 f6 04 24 01       	testb  $0x1,(%r12)
 396:	0f 84 16 04 00 00    	je     7b2 <machine_kexec_prepare+0x772>
 39c:	49 8b 04 24          	mov    (%r12),%rax
 3a0:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 3a8 <machine_kexec_prepare+0x368>
 3a7:	00 
 3a8:	0f 84 02 04 00 00    	je     7b0 <machine_kexec_prepare+0x770>
 3ae:	48 89 c7             	mov    %rax,%rdi
 3b1:	ff 14 25 00 00 00 00 	callq  *0x0
 3b8:	49 bd 00 00 00 00 00 	movabs $0xffff880000000000,%r13
 3bf:	88 ff ff 
 3c2:	48 89 da             	mov    %rbx,%rdx
 3c5:	48 b9 00 f0 ff ff ff 	movabs $0x3ffffffff000,%rcx
 3cc:	3f 00 00 
 3cf:	48 c1 ea 1b          	shr    $0x1b,%rdx
 3d3:	48 21 c8             	and    %rcx,%rax
 3d6:	81 e2 f8 0f 00 00    	and    $0xff8,%edx
 3dc:	4c 01 ea             	add    %r13,%rdx
 3df:	4c 8d 24 02          	lea    (%rdx,%rax,1),%r12
 3e3:	41 f6 04 24 01       	testb  $0x1,(%r12)
 3e8:	0f 84 46 03 00 00    	je     734 <machine_kexec_prepare+0x6f4>
 3ee:	49 8b 04 24          	mov    (%r12),%rax
 3f2:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 3fa <machine_kexec_prepare+0x3ba>
 3f9:	00 
 3fa:	0f 84 32 03 00 00    	je     732 <machine_kexec_prepare+0x6f2>
 400:	48 89 c7             	mov    %rax,%rdi
 403:	ff 14 25 00 00 00 00 	callq  *0x0
 40a:	48 b9 00 00 00 00 00 	movabs $0xffff880000000000,%rcx
 411:	88 ff ff 
 414:	48 89 da             	mov    %rbx,%rdx
 417:	48 c1 ea 12          	shr    $0x12,%rdx
 41b:	81 e2 f8 0f 00 00    	and    $0xff8,%edx
 421:	48 01 ca             	add    %rcx,%rdx
 424:	48 b9 00 f0 ff ff ff 	movabs $0x3ffffffff000,%rcx
 42b:	3f 00 00 
 42e:	48 21 c8             	and    %rcx,%rax
 431:	48 01 c2             	add    %rax,%rdx
 434:	f6 02 01             	testb  $0x1,(%rdx)
 437:	0f 84 57 02 00 00    	je     694 <machine_kexec_prepare+0x654>
 43d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
 441:	49 c7 c4 00 00 00 00 	mov    $0x0,%r12
 448:	48 b8 00 00 00 00 00 	movabs $0x160000000000,%rax
 44f:	16 00 00 
 452:	4c 89 e3             	mov    %r12,%rbx
 455:	48 03 42 28          	add    0x28(%rdx),%rax
 459:	48 c1 eb 24          	shr    $0x24,%rbx
 45d:	48 c1 f8 06          	sar    $0x6,%rax
 461:	48 ba 00 00 00 00 00 	movabs $0xffff880000000000,%rdx
 468:	88 ff ff 
 46b:	48 c1 e0 0c          	shl    $0xc,%rax
 46f:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
 475:	48 8d bc 10 00 10 00 	lea    0x1000(%rax,%rdx,1),%rdi
 47c:	00 
 47d:	e8 00 00 00 00       	callq  482 <machine_kexec_prepare+0x442>
 482:	48 03 5d 98          	add    -0x68(%rbp),%rbx
 486:	49 89 c5             	mov    %rax,%r13
 489:	f6 03 01             	testb  $0x1,(%rbx)
 48c:	75 60                	jne    4ee <machine_kexec_prepare+0x4ae>
 48e:	bf d0 00 00 00       	mov    $0xd0,%edi
 493:	e8 00 00 00 00       	callq  498 <machine_kexec_prepare+0x458>
 498:	48 85 c0             	test   %rax,%rax
 49b:	0f 84 90 03 00 00    	je     831 <machine_kexec_prepare+0x7f1>
 4a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
 4a5:	48 89 c7             	mov    %rax,%rdi
 4a8:	48 89 82 80 02 00 00 	mov    %rax,0x280(%rdx)
 4af:	e8 00 00 00 00       	callq  4b4 <machine_kexec_prepare+0x474>
 4b4:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 4bc <machine_kexec_prepare+0x47c>
 4bb:	00 
 4bc:	0f 84 82 03 00 00    	je     844 <machine_kexec_prepare+0x804>
 4c2:	48 89 c6             	mov    %rax,%rsi
 4c5:	48 83 ce 63          	or     $0x63,%rsi
 4c9:	48 89 f7             	mov    %rsi,%rdi
 4cc:	ff 14 25 00 00 00 00 	callq  *0x0
 4d3:	48 89 c6             	mov    %rax,%rsi
 4d6:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 4de <machine_kexec_prepare+0x49e>
 4dd:	00 
 4de:	0f 84 79 03 00 00    	je     85d <machine_kexec_prepare+0x81d>
 4e4:	48 89 df             	mov    %rbx,%rdi
 4e7:	ff 14 25 00 00 00 00 	callq  *0x0
 4ee:	48 8b 03             	mov    (%rbx),%rax
 4f1:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 4f9 <machine_kexec_prepare+0x4b9>
 4f8:	00 
 4f9:	0f 84 b1 02 00 00    	je     7b0 <machine_kexec_prepare+0x770>
 4ff:	48 89 c7             	mov    %rax,%rdi
 502:	ff 14 25 00 00 00 00 	callq  *0x0
 509:	48 b9 00 00 00 00 00 	movabs $0xffff880000000000,%rcx
 510:	88 ff ff 
 513:	4c 89 e2             	mov    %r12,%rdx
 516:	48 c1 ea 1b          	shr    $0x1b,%rdx
 51a:	81 e2 f8 0f 00 00    	and    $0xff8,%edx
 520:	48 01 ca             	add    %rcx,%rdx
 523:	48 b9 00 f0 ff ff ff 	movabs $0x3ffffffff000,%rcx
 52a:	3f 00 00 
 52d:	48 21 c8             	and    %rcx,%rax
 530:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
 534:	f6 03 01             	testb  $0x1,(%rbx)
 537:	75 60                	jne    599 <machine_kexec_prepare+0x559>
 539:	bf d0 00 00 00       	mov    $0xd0,%edi
 53e:	e8 00 00 00 00       	callq  543 <machine_kexec_prepare+0x503>
 543:	48 85 c0             	test   %rax,%rax
 546:	0f 84 e5 02 00 00    	je     831 <machine_kexec_prepare+0x7f1>
 54c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
 550:	48 89 c7             	mov    %rax,%rdi
 553:	48 89 82 88 02 00 00 	mov    %rax,0x288(%rdx)
 55a:	e8 00 00 00 00       	callq  55f <machine_kexec_prepare+0x51f>
 55f:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 567 <machine_kexec_prepare+0x527>
 566:	00 
 567:	0f 84 d9 02 00 00    	je     846 <machine_kexec_prepare+0x806>
 56d:	48 89 c6             	mov    %rax,%rsi
 570:	48 83 ce 63          	or     $0x63,%rsi
 574:	48 89 f7             	mov    %rsi,%rdi
 577:	ff 14 25 00 00 00 00 	callq  *0x0
 57e:	48 89 c6             	mov    %rax,%rsi
 581:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 589 <machine_kexec_prepare+0x549>
 588:	00 
 589:	0f 84 a0 02 00 00    	je     82f <machine_kexec_prepare+0x7ef>
 58f:	48 89 df             	mov    %rbx,%rdi
 592:	ff 14 25 00 00 00 00 	callq  *0x0
 599:	48 8b 03             	mov    (%rbx),%rax
 59c:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 5a4 <machine_kexec_prepare+0x564>
 5a3:	00 
 5a4:	0f 84 88 01 00 00    	je     732 <machine_kexec_prepare+0x6f2>
 5aa:	48 89 c7             	mov    %rax,%rdi
 5ad:	ff 14 25 00 00 00 00 	callq  *0x0
 5b4:	48 b9 00 00 00 00 00 	movabs $0xffff880000000000,%rcx
 5bb:	88 ff ff 
 5be:	4c 89 e2             	mov    %r12,%rdx
 5c1:	48 c1 ea 12          	shr    $0x12,%rdx
 5c5:	81 e2 f8 0f 00 00    	and    $0xff8,%edx
 5cb:	48 01 ca             	add    %rcx,%rdx
 5ce:	48 b9 00 f0 ff ff ff 	movabs $0x3ffffffff000,%rcx
 5d5:	3f 00 00 
 5d8:	48 21 c8             	and    %rcx,%rax
 5db:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
 5df:	f6 03 01             	testb  $0x1,(%rbx)
 5e2:	0f 84 e9 00 00 00    	je     6d1 <machine_kexec_prepare+0x691>
 5e8:	48 8b 13             	mov    (%rbx),%rdx
 5eb:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 5f3 <machine_kexec_prepare+0x5b3>
 5f2:	00 
 5f3:	0f 84 d6 00 00 00    	je     6cf <machine_kexec_prepare+0x68f>
 5f9:	48 89 d7             	mov    %rdx,%rdi
 5fc:	ff 14 25 00 00 00 00 	callq  *0x0
 603:	48 89 c2             	mov    %rax,%rdx
 606:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 60e <machine_kexec_prepare+0x5ce>
 60d:	00 
 60e:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 615 <machine_kexec_prepare+0x5d5>
 615:	0f 84 b2 00 00 00    	je     6cd <machine_kexec_prepare+0x68d>
 61b:	4c 89 ee             	mov    %r13,%rsi
 61e:	25 63 01 00 00       	and    $0x163,%eax
 623:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
 62a:	48 09 c6             	or     %rax,%rsi
 62d:	48 89 f7             	mov    %rsi,%rdi
 630:	ff 14 25 00 00 00 00 	callq  *0x0
 637:	48 89 c6             	mov    %rax,%rsi
 63a:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 642 <machine_kexec_prepare+0x602>
 641:	00 
 642:	0f 84 83 00 00 00    	je     6cb <machine_kexec_prepare+0x68b>
 648:	49 c1 ec 09          	shr    $0x9,%r12
 64c:	48 b8 00 f0 ff ff ff 	movabs $0x3ffffffff000,%rax
 653:	3f 00 00 
 656:	41 81 e4 f8 0f 00 00 	and    $0xff8,%r12d
 65d:	48 21 c2             	and    %rax,%rdx
 660:	48 bf 00 00 00 00 00 	movabs $0xffff880000000000,%rdi
 667:	88 ff ff 
 66a:	49 8d 3c 3c          	lea    (%r12,%rdi,1),%rdi
 66e:	48 01 d7             	add    %rdx,%rdi
 671:	ff 14 25 00 00 00 00 	callq  *0x0
 678:	31 c0                	xor    %eax,%eax
 67a:	eb 05                	jmp    681 <machine_kexec_prepare+0x641>
 67c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
 681:	48 83 c4 58          	add    $0x58,%rsp
 685:	5b                   	pop    %rbx
 686:	41 5c                	pop    %r12
 688:	41 5d                	pop    %r13
 68a:	41 5e                	pop    %r14
 68c:	41 5f                	pop    %r15
 68e:	c9                   	leaveq 
 68f:	c3                   	retq   
 690:	0f 0b                	ud2    
 692:	0f 0b                	ud2    
 694:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 69c <machine_kexec_prepare+0x65c>
 69b:	00 
 69c:	74 f2                	je     690 <machine_kexec_prepare+0x650>
 69e:	48 81 cb e3 01 00 00 	or     $0x1e3,%rbx
 6a5:	48 89 df             	mov    %rbx,%rdi
 6a8:	ff 14 25 00 00 00 00 	callq  *0x0
 6af:	48 89 c6             	mov    %rax,%rsi
 6b2:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 6ba <machine_kexec_prepare+0x67a>
 6b9:	00 
 6ba:	74 d6                	je     692 <machine_kexec_prepare+0x652>
 6bc:	48 89 d7             	mov    %rdx,%rdi
 6bf:	ff 14 25 00 00 00 00 	callq  *0x0
 6c6:	e9 72 fd ff ff       	jmpq   43d <machine_kexec_prepare+0x3fd>
 6cb:	0f 0b                	ud2    
 6cd:	0f 0b                	ud2    
 6cf:	0f 0b                	ud2    
 6d1:	bf d0 00 00 00       	mov    $0xd0,%edi
 6d6:	e8 00 00 00 00       	callq  6db <machine_kexec_prepare+0x69b>
 6db:	48 85 c0             	test   %rax,%rax
 6de:	0f 84 4d 01 00 00    	je     831 <machine_kexec_prepare+0x7f1>
 6e4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
 6e8:	48 89 c7             	mov    %rax,%rdi
 6eb:	48 89 82 90 02 00 00 	mov    %rax,0x290(%rdx)
 6f2:	e8 00 00 00 00       	callq  6f7 <machine_kexec_prepare+0x6b7>
 6f7:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 6ff <machine_kexec_prepare+0x6bf>
 6fe:	00 
 6ff:	74 8f                	je     690 <machine_kexec_prepare+0x650>
 701:	48 89 c6             	mov    %rax,%rsi
 704:	48 83 ce 63          	or     $0x63,%rsi
 708:	48 89 f7             	mov    %rsi,%rdi
 70b:	ff 14 25 00 00 00 00 	callq  *0x0
 712:	48 89 c6             	mov    %rax,%rsi
 715:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 71d <machine_kexec_prepare+0x6dd>
 71c:	00 
 71d:	0f 84 6f ff ff ff    	je     692 <machine_kexec_prepare+0x652>
 723:	48 89 df             	mov    %rbx,%rdi
 726:	ff 14 25 00 00 00 00 	callq  *0x0
 72d:	e9 b6 fe ff ff       	jmpq   5e8 <machine_kexec_prepare+0x5a8>
 732:	0f 0b                	ud2    
 734:	31 f6                	xor    %esi,%esi
 736:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
 73a:	e8 00 00 00 00       	callq  73f <machine_kexec_prepare+0x6ff>
 73f:	48 85 c0             	test   %rax,%rax
 742:	0f 84 34 ff ff ff    	je     67c <machine_kexec_prepare+0x63c>
 748:	48 ba 00 00 00 00 00 	movabs $0x160000000000,%rdx
 74f:	16 00 00 
 752:	48 01 d0             	add    %rdx,%rax
 755:	48 c1 f8 06          	sar    $0x6,%rax
 759:	48 c1 e0 0c          	shl    $0xc,%rax
 75d:	4e 8d 2c 28          	lea    (%rax,%r13,1),%r13
 761:	4c 89 ef             	mov    %r13,%rdi
 764:	e8 00 00 00 00       	callq  769 <machine_kexec_prepare+0x729>
 769:	4c 89 ef             	mov    %r13,%rdi
 76c:	e8 00 00 00 00       	callq  771 <machine_kexec_prepare+0x731>
 771:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 779 <machine_kexec_prepare+0x739>
 778:	00 
 779:	0f 84 c7 00 00 00    	je     846 <machine_kexec_prepare+0x806>
 77f:	48 89 c6             	mov    %rax,%rsi
 782:	48 83 ce 63          	or     $0x63,%rsi
 786:	48 89 f7             	mov    %rsi,%rdi
 789:	ff 14 25 00 00 00 00 	callq  *0x0
 790:	48 89 c6             	mov    %rax,%rsi
 793:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 79b <machine_kexec_prepare+0x75b>
 79a:	00 
 79b:	0f 84 8e 00 00 00    	je     82f <machine_kexec_prepare+0x7ef>
 7a1:	4c 89 e7             	mov    %r12,%rdi
 7a4:	ff 14 25 00 00 00 00 	callq  *0x0
 7ab:	e9 3e fc ff ff       	jmpq   3ee <machine_kexec_prepare+0x3ae>
 7b0:	0f 0b                	ud2    
 7b2:	31 f6                	xor    %esi,%esi
 7b4:	48 89 c7             	mov    %rax,%rdi
 7b7:	e8 00 00 00 00       	callq  7bc <machine_kexec_prepare+0x77c>
 7bc:	48 85 c0             	test   %rax,%rax
 7bf:	0f 84 b7 fe ff ff    	je     67c <machine_kexec_prepare+0x63c>
 7c5:	48 ba 00 00 00 00 00 	movabs $0x160000000000,%rdx
 7cc:	16 00 00 
 7cf:	49 bd 00 00 00 00 00 	movabs $0xffff880000000000,%r13
 7d6:	88 ff ff 
 7d9:	48 01 d0             	add    %rdx,%rax
 7dc:	48 c1 f8 06          	sar    $0x6,%rax
 7e0:	48 c1 e0 0c          	shl    $0xc,%rax
 7e4:	4e 8d 2c 28          	lea    (%rax,%r13,1),%r13
 7e8:	4c 89 ef             	mov    %r13,%rdi
 7eb:	e8 00 00 00 00       	callq  7f0 <machine_kexec_prepare+0x7b0>
 7f0:	4c 89 ef             	mov    %r13,%rdi
 7f3:	e8 00 00 00 00       	callq  7f8 <machine_kexec_prepare+0x7b8>
 7f8:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 800 <machine_kexec_prepare+0x7c0>
 7ff:	00 
 800:	74 42                	je     844 <machine_kexec_prepare+0x804>
 802:	48 89 c6             	mov    %rax,%rsi
 805:	48 83 ce 63          	or     $0x63,%rsi
 809:	48 89 f7             	mov    %rsi,%rdi
 80c:	ff 14 25 00 00 00 00 	callq  *0x0
 813:	48 89 c6             	mov    %rax,%rsi
 816:	48 83 3d 00 00 00 00 	cmpq   $0x0,0x0(%rip)        # 81e <machine_kexec_prepare+0x7de>
 81d:	00 
 81e:	74 3d                	je     85d <machine_kexec_prepare+0x81d>
 820:	4c 89 e7             	mov    %r12,%rdi
 823:	ff 14 25 00 00 00 00 	callq  *0x0
 82a:	e9 6d fb ff ff       	jmpq   39c <machine_kexec_prepare+0x35c>
 82f:	0f 0b                	ud2    
 831:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
 835:	e8 c6 f7 ff ff       	callq  0 <free_transition_pgtable>
 83a:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
 83f:	e9 3d fe ff ff       	jmpq   681 <machine_kexec_prepare+0x641>
 844:	0f 0b                	ud2    
 846:	0f 0b                	ud2    
 848:	48 8b 45 98          	mov    -0x68(%rbp),%rax
 84c:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
 853:	00 
 854:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 858:	e9 b3 fa ff ff       	jmpq   310 <machine_kexec_prepare+0x2d0>
 85d:	0f 0b                	ud2    
 85f:	90                   	nop


--=-xCUYlWu1nVrQAv+QdvSu--

